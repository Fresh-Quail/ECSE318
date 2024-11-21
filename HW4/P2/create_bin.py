num_entries = 2**16  # 65536 entries

# File name
file_path = "./data_mem.bin"

# Create the binary file
with open(file_path, "wb") as f:
    for i in range(num_entries):
        # Write each index as a 32-bit unsigned integer in binary format
        f.write(i.to_bytes(4, byteorder='big'))

file_path