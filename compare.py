required_rpms = ['binutils']
current_rpms = ['binutils']

required_rpms = set(required_rpms)
current_rpms = set(current_rpms)

complete_rpms = required_rpms.union(current_rpms)
complete_rpms = list(complete_rpms)

print(complete_rpms)
