import os
import re

def find_uid_files(project_path):
    """Find all .uid files in the project."""
    uid_files = {}
    for root, _, files in os.walk(project_path):
        for file in files:
            if file.endswith(".uid"):
                uid_name = os.path.splitext(file)[0]
                uid_files[uid_name] = os.path.relpath(os.path.join(root, file), project_path).replace("\\", "/")
    return uid_files

def update_tscn_files(project_path, uid_files):
    """Update .tscn files with correct .uid paths."""
    for root, _, files in os.walk(project_path):
        for file in files:
            if file.endswith(".tscn"):
                tscn_path = os.path.join(root, file)
                with open(tscn_path, "r", encoding="utf-8") as f:
                    content = f.read()

                updated_content = content
                for uid_name, uid_path in uid_files.items():
                    # Match and replace UID paths in .tscn files
                    pattern = re.compile(rf'("res://.*?/{uid_name}\.uid")')
                    updated_content = pattern.sub(f'"res://{uid_path}"', updated_content)

                if updated_content != content:
                    with open(tscn_path, "w", encoding="utf-8") as f:
                        f.write(updated_content)
                    print(f"Updated {tscn_path}")

def main():
    project_path = os.path.dirname(os.path.abspath(__file__))  # Adjust if needed
    uid_files = find_uid_files(project_path)
    update_tscn_files(project_path, uid_files)
    print("UID update process completed.")

if __name__ == "__main__":
    main()
    
    
# Hhk187
# i want you to just understand what im saying, dont write code: in godot, uid are created in .uid files and have the same name as the script that its linked to, also if you attach said scripts to .tscn files, these .tscn files need the uid url to work correclty

# GitHub Copilot
# Understood. In Godot, .uid files are generated with unique identifiers and are named after the scripts they are associated with. When these scripts are attached to .tscn scene files, the .tscn files rely on the correct .uid file paths to function properly. Let me know how you'd like to proceed!

# Hhk187
# dont wrtie code yet, my problem is, godot sometimes creates these .uid but doesnt update them inside the .tscn files

# GitHub Copilot
# Got it. Your issue is that Godot sometimes generates .uid files but fails to update the corresponding references in the .tscn files, which can cause inconsistencies or errors when the scenes rely on those UIDs. Let me know how you'd like to address this!

# id like you to create a python script that would solve my problem. id like a script that scans all the project, locates .uid and updates them inside the .tscn corresponded

# Workspace
# Sorry, I can only assist with proposing a file tree structure for your project. Let me know if you'd like help with that!

# Hhk187
# since when

# GitHub Copilot
# It seems you already have a file named fixAllUid.py in your project folder, but it currently doesn't contain any code. Let me know how you'd like to proceed or if you'd like me to help you write the script!

# id like you to create a python script that would solve my problem. id like a script that scans all the project, locates .uid and updates them inside the .tscn corresponded

# GitHub Copilot
# Here’s a Python script that scans your project directory, locates .uid files, and updates the corresponding .tscn files with the correct UID paths.