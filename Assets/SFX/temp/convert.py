import os




allowed_extensions = {'.webm'} 
def convert_webm_to_wav(input_file, output_file):
    """Convert a WEBM audio file to WAV format using ffmpeg."""
    import subprocess
    try:
        cmd = [
            'ffmpeg',
            '-y',  # Overwrite output files without asking
            '-i', str(input_file),
            str(output_file)
        ]
        
        # Run ffmpeg with suppressed output
        result = subprocess.run(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False
        )
        
        return result.returncode == 0
    except Exception as e:
        print(f"Error converting {input_file} to WAV: {str(e)}")
        return False

for root, dirs, files in os.walk('.'):
    for file in files:
        file_path = os.path.join(root, file)
        file_ext = os.path.splitext(file)[1].lower()
        
        if file_ext in allowed_extensions:
            output_file = os.path.splitext(file_path)[0] + '.wav'
            success = convert_webm_to_wav(file_path, output_file)
            
            if success:
                print(f"Converted: {file_path} to {output_file}")
                try:
                    os.remove(file_path)
                    print(f"Deleted source file: {file_path}")
                except Exception as e:
                    print(f"Failed to delete {file_path}: {str(e)}")
            else:
                print(f"Failed to convert: {file_path}")

