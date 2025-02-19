![image](https://github.com/user-attachments/assets/7d0f2442-d8db-4cd2-9a2b-7bf471131b44)

Pipelined MIPS Processor
This project implements a pipelined MIPS processor written in VHDL, designed for integration on an Altera FPGA. The architecture efficiently executes instructions with support for stalls and flushes to handle hazards and maintain correct program behavior.
The design follows a five-stage pipeline, with each stage handled by a distinct sub-entity:

1. Ifetch (Instruction Fetch):
Reads program instructions and data from memory.
Passes the instruction to the next pipeline stage.

2. Idecode (Instruction Decode):
Decodes the instruction fetched by Ifetch.
Reads/writes data to/from registers as required by the instruction.

3. Execute:
Performs mathematical or logical operations on data from Idecode registers.
Outputs results for memory access or writes back to registers.

4. Dmemory (Data Memory):
Handles load and store operations.
Manages memory access as specified by the instruction.

5. Write Back:
Stores the result of execute stage in memory.

 
Control:
Enables or disables control signals for all components based on the current instruction.
Ensures correct operation and hazard handling.

Features
Pipelined Execution: Five-stage pipeline ensures efficient instruction throughput.
Hazard Handling: Supports stalls and flushes for resolving data and control hazards.
Supported Instructions: Implements the instructions specified by assignment requirements.
FPGA Integration: Designed for synthesis and deployment on FPGA hardware.
Deliverables
RTL Code: Fully implemented in VHDL.
Documentation: Includes design overview, block diagrams, and operational details.
Tested and verified on Quartus, ModelSim and QuestaSim. Integrated on Altera FPGA.
