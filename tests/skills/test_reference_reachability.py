import importlib.util
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


TESTS_DIR = Path(__file__).resolve().parent
REPOSITORY_ROOT = TESTS_DIR.parent.parent
CHECKER_PATH = TESTS_DIR / "reference_reachability.py"


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


class ReferenceReachabilityTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary_directory.cleanup)
        self.skills_root = Path(self.temporary_directory.name) / "skills"

    def load_checker(self):
        self.assertTrue(CHECKER_PATH.exists(), "reference reachability checker is missing")
        spec = importlib.util.spec_from_file_location("reference_reachability", CHECKER_PATH)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module

    def add_skill(self, name, skill_text="# Skill\n", references=None):
        skill_root = self.skills_root / name
        write(skill_root / "SKILL.md", skill_text)
        for relative_path, text in (references or {}).items():
            write(skill_root / "references" / relative_path, text)
        return skill_root

    def unreachable(self):
        return [
            path.relative_to(self.skills_root.resolve()).as_posix()
            for path in self.load_checker().find_unreachable(self.skills_root)
        ]

    def test_follows_direct_transitive_bare_sibling_and_fragment_links(self):
        self.add_skill(
            "alpha",
            "[Start](references/direct.md#start)\n",
            {
                "direct.md": "[Nested](nested/child.md) and `bare.md`\n",
                "bare.md": "bare\n",
                "nested/child.md": "child\n",
            },
        )

        self.assertEqual([], self.unreachable())

    def test_follows_cross_skill_paths_under_skills(self):
        self.add_skill("alpha", "[Shared](../beta/references/shared.md)\n")
        write(self.skills_root / "beta" / "references" / "shared.md", "shared\n")

        self.assertEqual([], self.unreachable())

    def test_reports_orphan_and_disconnected_cycle_in_sorted_order(self):
        self.add_skill(
            "alpha",
            references={
                "z-orphan.md": "orphan\n",
                "cycle/b.md": "[A](a.md)\n",
                "cycle/a.md": "[B](b.md)\n",
            },
        )

        self.assertEqual(
            [
                "alpha/references/cycle/a.md",
                "alpha/references/cycle/b.md",
                "alpha/references/z-orphan.md",
            ],
            self.unreachable(),
        )

    def test_reachable_cycle_does_not_hang_or_report_files(self):
        self.add_skill(
            "alpha",
            "[A](references/a.md)\n",
            {
                "a.md": "[B](b.md)\n",
                "b.md": "[A](a.md)\n",
            },
        )

        self.assertEqual([], self.unreachable())

    def test_qa_close_and_probes_chain_must_remain_reachable(self):
        skill_root = self.add_skill(
            "batuta-qa-run",
            "[Close](references/close.md)\n",
            {
                "close.md": "[Probes](probes.md)\n",
                "probes.md": "probes\n",
            },
        )
        self.assertEqual([], self.unreachable())

        write(skill_root / "SKILL.md", "# QA run\n")
        self.assertEqual(
            [
                "batuta-qa-run/references/close.md",
                "batuta-qa-run/references/probes.md",
            ],
            self.unreachable(),
        )

        write(skill_root / "SKILL.md", "[Close](references/close.md)\n")
        write(skill_root / "references" / "close.md", "close\n")
        self.assertEqual(
            ["batuta-qa-run/references/probes.md"],
            self.unreachable(),
        )

        write(skill_root / "references" / "close.md", "[Probes](probes.md)\n")
        self.assertEqual([], self.unreachable())

    def test_ignores_remote_urls_placeholders_and_paths_outside_skills(self):
        self.add_skill(
            "alpha",
            "[Remote](https://example.com/remote.md) `<id>.md` [Outside](../../outside.md)\n",
        )
        write(Path(self.temporary_directory.name) / "outside.md", "outside\n")

        self.assertEqual([], self.unreachable())

    def test_public_gate_propagates_checker_failure_and_exact_path(self):
        repository_copy = Path(self.temporary_directory.name) / "repository"
        shutil.copytree(
            REPOSITORY_ROOT,
            repository_copy,
            ignore=shutil.ignore_patterns(".git", ".batuta", "__pycache__"),
        )
        (repository_copy / "tests" / "skills" / Path(__file__).name).unlink()
        orphan = repository_copy / "skills" / "batuta" / "references" / "injected-orphan.md"
        write(orphan, "orphan\n")

        environment = os.environ.copy()
        environment["PYTHONDONTWRITEBYTECODE"] = "1"
        result = subprocess.run(
            ["bash", "tests/skills/check.sh"],
            cwd=repository_copy,
            env=environment,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )

        self.assertNotEqual(0, result.returncode, result.stdout)
        self.assertIn(
            "skills/batuta/references/injected-orphan.md",
            result.stdout,
        )


if __name__ == "__main__":
    unittest.main()
