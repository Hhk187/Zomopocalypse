import os

def remove_import_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.import'):
                file_path = os.path.join(root, file)
                os.remove(file_path)
                print(f"Removed: {file_path}")

if __name__ == "__main__":
    directory = '../'
    remove_import_files(directory)