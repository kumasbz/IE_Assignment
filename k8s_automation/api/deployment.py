import subprocess

def create_deployment(data):
    try:
        namespace = data['namespace']
        deployment_name = data['name']
        image = data['image']
        cpu_request = data['cpu_request']
        cpu_limit = data['cpu_limit']
        memory_request = data['memory_request']
        memory_limit = data['memory_limit']
        port = data['port']
        cpu_target = data['cpu_target']
        memory_target = data['memory_target']

        command = (
            f"scripts/create_deployment.sh {namespace} {deployment_name} {image} {cpu_request} {cpu_limit} "
            f"{memory_request} {memory_limit} {port} {cpu_target} {memory_target}"
        )
        subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
        return {"status": "success", "message": f"Deployment {deployment_name} created successfully in namespace {namespace}"}
    except subprocess.CalledProcessError as e:
        return {"status": "error", "message": e.output.decode()}
