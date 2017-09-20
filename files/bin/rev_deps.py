# rev_deps.py
import pip 
import sys 

def find_reverse_deps(package_name, local=True):
    if package_name.lower() in [pkg.project_name.lower() for pkg in pip.get_installed_distributions(local_only=local)]:
        output = [ 
            pkg.project_name for pkg in pip.get_installed_distributions(local_only=local)
            if package_name.lower() in {req.project_name.lower() for req in pkg.requires()}
        ]
    else:
        output = "package {0} not found".format(package_name)
    return output

if __name__ == '__main__':
    if (len(sys.argv) <= 2): 
        local = True
    else:
        if sys.argv[2].lower() == 'false':
            local = False
        else:
            local = True
    print find_reverse_deps(sys.argv[1], local)
