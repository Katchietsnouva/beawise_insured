import os


EXCLUDE_DIRS = {"build", ".git", ".dart_tool", ".idea"}


def print_tree(start_path, prefix=""):
    entries = sorted(
        e for e in os.listdir(start_path)
        if e not in EXCLUDE_DIRS
    )

    entries_count = len(entries)

    for index, entry in enumerate(entries):
        path = os.path.join(start_path, entry)
        connector = "└── " if index == entries_count - 1 else "├── "

        print(prefix + connector + entry)

        if os.path.isdir(path):
            extension = "    " if index == entries_count - 1 else "│   "
            print_tree(path, prefix + extension)


if __name__ == "__main__":
    # Resolve project root (where script is executed)
    project_root = os.getcwd()

    # Force target directory to be lib/
    lib_path = os.path.join(project_root, "lib")

    if not os.path.exists(lib_path):
        print("❌ No lib/ folder found in current directory.")
        exit(1)

    print("lib")
    print_tree(lib_path)
    
    
    
    # import os


# def print_tree(start_path, prefix=""):
#     entries = sorted(os.listdir(start_path))
#     entries_count = len(entries)

#     for index, entry in enumerate(entries):
#         path = os.path.join(start_path, entry)
#         connector = "└── " if index == entries_count - 1 else "├── "

#         print(prefix + connector + entry)

#         if os.path.isdir(path):
#             extension = "    " if index == entries_count - 1 else "│   "
#             print_tree(path, prefix + extension)


# if __name__ == "__main__":
#     directory = input("Enter directory path (or press Enter for current): ").strip()
#     if not directory:
#         directory = "."

#     print(directory)
#     print_tree(directory)