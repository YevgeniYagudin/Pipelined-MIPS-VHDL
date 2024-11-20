The design includes a pipelined MIPS architecture.

Supported instructions are according to the assignment requirements.

The architecture supports stalls and flushes.

The top entity includes 5 main sub entities:

1.	Ifetch: Reads the program data, the instruction, and passes it to the next element.

2.	Idecode: Gets the instruction from Ifetch and reads/writes to registers.

3.	Control: Gets the instruction from Ifetch and enables/disables control signals to all relevant components.

4.	Execute: Gets the instruction from Idecode and applies mathematical operations on data given by Idecode registers.

5.	Dmemory: Loads and stores data according to instruction.