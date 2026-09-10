#!/usr/bin/env python3
import re
import sys
from pathlib import Path


MARKDOWN_LINK = re.compile(r"\[[^\]]*\]\(([^\s)]+)")
BACKTICK_CITATION = re.compile(r"`([^`\n]*?\.md(?:#[^`\s]+)?)`")
PLACEHOLDER_CHARACTERS = frozenset("<>{}*")


def cited_paths(markdown):
    return MARKDOWN_LINK.findall(markdown) + BACKTICK_CITATION.findall(markdown)


def owning_skill_root(path, skills_root):
    relative = path.relative_to(skills_root)
    return skills_root / relative.parts[0]


def resolve_citation(citation, citing_file, skills_root):
    citation = citation.strip("<>").split("#", 1)[0]
    if (
        not citation.endswith(".md")
        or "://" in citation
        or any(character in citation for character in PLACEHOLDER_CHARACTERS)
    ):
        return None

    candidates = [
        citing_file.parent / citation,
        owning_skill_root(citing_file, skills_root) / citation,
        skills_root / citation.removeprefix("skills/"),
    ]
    for candidate in candidates:
        candidate = candidate.resolve()
        if candidate.is_relative_to(skills_root) and candidate.is_file():
            return candidate
    return None


def find_unreachable(skills_root):
    skills_root = Path(skills_root).resolve()
    pending = sorted(skills_root.glob("*/SKILL.md"), reverse=True)
    visited = set()

    while pending:
        markdown_file = pending.pop()
        markdown_file = markdown_file.resolve()
        if markdown_file in visited:
            continue
        visited.add(markdown_file)
        markdown = markdown_file.read_text(encoding="utf-8")
        for citation in cited_paths(markdown):
            target = resolve_citation(citation, markdown_file, skills_root)
            if target is not None and target not in visited:
                pending.append(target)

    references = {
        path.resolve()
        for path in skills_root.glob("*/references/**/*.md")
        if path.is_file()
    }
    return sorted(references - visited)


def main(arguments):
    skills_root = Path(arguments[0] if arguments else "skills")
    unreachable = find_unreachable(skills_root)
    for path in unreachable:
        relative = path.relative_to(skills_root.resolve())
        print(f"unreachable reference: {skills_root.name}/{relative.as_posix()}")
    return 1 if unreachable else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
