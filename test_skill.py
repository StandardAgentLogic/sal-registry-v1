from skills.skill_registry import answer_with_db_skills


def main() -> None:
    question = "As a Legal Specialist, what are the 5 safety protocols for a Judicial Law Clerk?"
    print(f"Q: {question}\n")
    print(answer_with_db_skills(question))


if __name__ == "__main__":
    main()

