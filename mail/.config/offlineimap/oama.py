import subprocess

def get_token(email_address):
    return subprocess.run(["oama", "access", email_address], capture_output=True, text=True).stdout
