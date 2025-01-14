## Brief ##
This repository collects some projects for my GCN assembly learning roads.

## How to Build
Clone this repository, `cd` to it, and then

```bash
mkdir build
cd build
cmake .. -DCMAKE_CXX_COMPILER=hipcc -DCMAKE_C_COMPILER=hipcc -DCMAKE_PREFIX_PATH=/opt/rocm/lib/cmake
make -j
```

## Introduction for each lesson

### Lesson 0

- How to set up the host part to launch assembly kernel and use 1 thread to set a value with specified value in assembly code.
- Set up buffer resource descriptor


### Lesson 1

- How to set up buffer resource descriptor
- Set exec mask to make lanes active/inactive

### Lesson 2

- Implement relu and leaky relu in both hip and assembly code

### Lesson 3

- Demonstrate how to use reduction method to get the maximum value via multiple threads in GPU
- Please refer to my diagram to understand the assembly algorithm if you are new to assembly.


![IMG_1912](https://github.com/user-attachments/assets/5a09cbec-7177-4b81-aa82-97d75f51c4b5)
