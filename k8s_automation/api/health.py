import subprocess

def get_health_status(namespace, deployment_id):
    try:
        command = f"scripts/get_health_status.sh {namespace} {deployment_id}"
        output = subprocess.check_output(command, shell=True).decode().strip()
        return output
    except subprocess.CalledProcessError as e:
        return "error"
