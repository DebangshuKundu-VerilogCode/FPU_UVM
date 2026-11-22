class normal_add_seq extends uvm_sequence #(trans);
  `uvm_object_utils(normal_add_seq)

  function new(string name = "normal_add_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  // write_en high 2 cycles, data held 3 cycles, then idle
  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00);   // let rd_ptr advance
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00);   // let reset settle

    write_byte(8'hB7);  // A low  (0x3E00)
    write_byte(8'h8B);  // A high
    write_byte(8'h3C);  // B low  (0x4080)
    write_byte(8'h14);  // B high

    // start, opcode=0 (ADD)
    send_cycle(8'h04, 8'h00);
    send_cycle(8'h04, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00);  // wait for done

    read_byte();   // expect 0x80
    read_byte();   // expect 0x43  -> result 0x4380 (3.75)
  endtask
endclass

/*class normal_sub_seq extends uvm_sequence #(trans);
  `uvm_object_utils(normal_sub_seq)

  function new(string name = "normal_sub_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  // write_en high 2 cycles, data held 3 cycles, then idle
  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00);   // let rd_ptr advance
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00);   // let reset settle

    // Operand A = 5.5 = 16'h4580
    write_byte(8'h80);  // A low
    write_byte(8'h45);  // A high

    // Operand B = 2.25 = 16'h4080
    write_byte(8'h80);  // B low
    write_byte(8'h40);  // B high

    // start, opcode=1 (SUB)
    send_cycle(8'h0C, 8'h00);
    send_cycle(8'h0C, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00);  // wait for done

    read_byte();   // expect 0x80 (result low byte)
    read_byte();   // expect 0x42 (result high byte) -> 0x4280 (3.25)
  endtask
endclass

class negative_add_seq extends uvm_sequence #(trans);
  `uvm_object_utils(negative_add_seq)

  function new(string name = "negative_add_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  // write_en high 2 cycles, data held 3 cycles, then idle
  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00); // let rd_ptr advance
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00); // let reset settle

    // Operand A = -1.5 = 16'hBE00
    write_byte(8'h00);  // A low
    write_byte(8'hBE);  // A high

    // Operand B = -2.25 = 16'hC080
    write_byte(8'h80);  // B low
    write_byte(8'hC0);  // B high

    // Start, opcode=0 (ADD)
    send_cycle(8'h04, 8'h00);
    send_cycle(8'h04, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00); // wait for done

    read_byte();  // expect 0x80
    read_byte();  // expect 0xC3 -> result C380 (-3.75)
  endtask
endclass

class mixed_sign_add_seq extends uvm_sequence #(trans);
  `uvm_object_utils(mixed_sign_add_seq)

  function new(string name = "mixed_sign_add_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  // write_en high 2 cycles, data held 3 cycles, then idle
  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00); // let rd_ptr advance
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00); // let reset settle

    // Operand A = +5.5 = 16'h4580
    write_byte(8'h80);  // A low
    write_byte(8'h45);  // A high

    // Operand B = -2.25 = 16'hC080
    write_byte(8'h80);  // B low
    write_byte(8'hC0);  // B high

    // Start, opcode=0 (ADD)
    send_cycle(8'h04, 8'h00);
    send_cycle(8'h04, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00); // wait for done

    read_byte();  // expect 0x80
    read_byte();  // expect 0x42 -> result 4280 (+3.25)
  endtask
endclass

class mixed_sign_sub_seq extends uvm_sequence #(trans);
  `uvm_object_utils(mixed_sign_sub_seq)

  function new(string name = "mixed_sign_sub_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  // write_en high 2 cycles, data held 3 cycles, then idle
  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00); // let rd_ptr advance
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00); // let reset settle

    // Operand A = +5.5 = 16'h4580
    write_byte(8'h80);  // A low
    write_byte(8'h45);  // A high

    // Operand B = -2.25 = 16'hC080
    write_byte(8'h80);  // B low
    write_byte(8'hC0);  // B high

    // Start, opcode=1 (SUB)
    send_cycle(8'h0C, 8'h00);
    send_cycle(8'h0C, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00); // wait for done

    read_byte();  // expect 0xC0
    read_byte();  // expect 0x47 -> result 47C0 (+7.75)
  endtask
endclass

class positive_inf_seq extends uvm_sequence #(trans);
  `uvm_object_utils(positive_inf_seq)

  function new(string name = "positive_inf_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00);
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00);

    // A = +Infinity = 16'h7C00
    write_byte(8'h00);  // A low
    write_byte(8'h7C);  // A high

    // B = +1.5 = 16'h3E00
    write_byte(8'h00);  // B low
    write_byte(8'h3E);  // B high

    // Start, opcode = 0 (ADD)
    send_cycle(8'h04, 8'h00);
    send_cycle(8'h04, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00);

    // Optional: read result bytes if your DUT/spec defines
    // a result value for error cases.
    // read_byte();
    // read_byte();
  endtask
endclass

class nan_seq extends uvm_sequence #(trans);
  `uvm_object_utils(nan_seq)

  function new(string name = "nan_seq");
    super.new(name);
  endfunction

  task send_cycle(bit [7:0] control, bit [7:0] data);
    trans req = trans::type_id::create("req");
    start_item(req);
    req.ui_in  = control;
    req.uio_in = data;
    finish_item(req);
  endtask

  task write_byte(bit [7:0] data);
    send_cycle(8'h01, data);
    send_cycle(8'h01, data);
    send_cycle(8'h00, data);
    send_cycle(8'h00, 8'h00);
  endtask

  task read_byte();
    send_cycle(8'h02, 8'h00);
    send_cycle(8'h02, 8'h00);
    repeat(3) send_cycle(8'h00, 8'h00);
  endtask

  task body();
    repeat(5) send_cycle(8'h00, 8'h00);

    // A = NaN = 16'h7E00
    write_byte(8'h00);  // A low
    write_byte(8'h7E);  // A high

    // B = +1.5 = 16'h3E00
    write_byte(8'h00);  // B low
    write_byte(8'h3E);  // B high

    // Start, opcode = 0 (ADD)
    send_cycle(8'h04, 8'h00);
    send_cycle(8'h04, 8'h00);
    repeat(12) send_cycle(8'h00, 8'h00);

    // No result read required for error case unless specified.
  endtask
endclass

class denormal_seq extends uvm_sequence #(trans);
    `uvm_object_utils(denormal_seq)
    function new(string name="denormal_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task body();
        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 0001 (denormal)
        write_byte(8'h01);  // A low byte
        write_byte(8'h00);  // A high byte

        // Operand B = 3E00 (1.5)
        write_byte(8'h00);  // B low byte
        write_byte(8'h3E);  // B high byte

        // Start ADD operation
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for operation completion
        repeat(12)
            send_cycle(8'h00, 8'h00);
    endtask
endclass

class equal_sub_seq extends uvm_sequence #(trans);
    `uvm_object_utils(equal_sub_seq)
    function new(string name="equal_sub_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;
        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();
        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 1.5 (3E00)
        write_byte(8'h00);  // A low byte
        write_byte(8'h3E);  // A high byte

        // Operand B = 1.5 (3E00)
        write_byte(8'h00);  // B low byte
        write_byte(8'h3E);  // B high byte

        // Start SUB operation (ui_in[3] = 1, ui_in[2] = 1)
        send_cycle(8'h0C, 8'h00);
        send_cycle(8'h0C, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result bytes
        read_byte();  // Expected low byte = 00
        read_byte();  // Expected high byte = 00
    endtask
endclass

class random_normal_add_seq extends uvm_sequence #(trans);
    `uvm_object_utils(random_normal_add_seq)
    rand bit [15:0] operand_a;
    rand bit [15:0] operand_b;
    // Restrict to normal FP16 values with moderate exponents
    constraint normal_c {
        operand_a[14:10] inside {[10:20]};
        operand_b[14:10] inside {[10:20]};
    }
    function new(string name="random_normal_add_seq");
        super.new(name);
    endfunction
    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;
        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Run 5 randomized addition transactions
        repeat(5) begin
            if (!randomize(operand_a, operand_b))
                `uvm_fatal("RAND", "Operand randomization failed")
            `uvm_info("RANDOM_ADD",
                $sformatf("A = %h, B = %h",
                          operand_a, operand_b),
                UVM_MEDIUM)

            // Write operand A (LSB first)
            write_byte(operand_a[7:0]);
            write_byte(operand_a[15:8]);

            // Write operand B (LSB first)
            write_byte(operand_b[7:0]);
            write_byte(operand_b[15:8]);

            // Start ADD
            send_cycle(8'h04, 8'h00);
            send_cycle(8'h04, 8'h00);

            // Wait for operation completion
            repeat(12)
                send_cycle(8'h00, 8'h00);

            // Read result low byte
            read_byte();

            // Read result high byte
            read_byte();
        end
    endtask
endclass

class zero_minus_nonzero_seq extends uvm_sequence #(trans);

    `uvm_object_utils(zero_minus_nonzero_seq)

    function new(string name="zero_minus_nonzero_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = +0 (0000)
        write_byte(8'h00);  // A low
        write_byte(8'h00);  // A high

        // Operand B = +1.5 (3E00)
        write_byte(8'h00);  // B low
        write_byte(8'h3E);  // B high

        // Start SUB (0 - 1.5)
        send_cycle(8'h0C, 8'h00);
        send_cycle(8'h0C, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Low byte = 00
        read_byte();  // High byte = BE

    endtask

endclass

class start_before_operands_seq extends uvm_sequence #(trans);

    `uvm_object_utils(start_before_operands_seq)

    function new(string name="start_before_operands_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Assert START before loading operands
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Deassert START
        repeat(3)
            send_cycle(8'h00, 8'h00);

        // Now load A = 1.5 (3E00)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Load B = 2.25 (4080)
        write_byte(8'h80);
        write_byte(8'h40);

        // Assert START again after loading operands
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();
        read_byte();

    endtask

endclass

class equal_exponent_add_seq extends uvm_sequence #(trans);

    `uvm_object_utils(equal_exponent_add_seq)

    function new(string name="equal_exponent_add_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 3E00 (1.5)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Operand B = 3F00 (1.75)
        write_byte(8'h00);
        write_byte(8'h3F);

        // Start ADD
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Expected 80
        read_byte();  // Expected 42

    endtask

endclass

class different_exponent_add_seq extends uvm_sequence #(trans);

    `uvm_object_utils(different_exponent_add_seq)

    function new(string name="different_exponent_add_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 3E00 (1.5)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Operand B = 4400 (4.0)
        write_byte(8'h00);
        write_byte(8'h44);

        // Start ADD
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Expected low byte = 80
        read_byte();  // Expected high byte = 43

    endtask

endclass

class carry_out_add_seq extends uvm_sequence #(trans);

    `uvm_object_utils(carry_out_add_seq)

    function new(string name="carry_out_add_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 3E00 (1.5)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Operand B = 3E00 (1.5)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Start ADD
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Expected low byte = 00
        read_byte();  // Expected high byte = 42

    endtask

endclass

class exponent_overflow_add_seq extends uvm_sequence #(trans);

    `uvm_object_utils(exponent_overflow_add_seq)

    function new(string name="exponent_overflow_add_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 7BFF
        write_byte(8'hFF);
        write_byte(8'h7B);

        // Operand B = 7BFF
        write_byte(8'hFF);
        write_byte(8'h7B);

        // Start ADD
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Expected low byte = 00
        read_byte();  // Expected high byte = 7C

    endtask

endclass

class underflow_sub_seq extends uvm_sequence #(trans);

    `uvm_object_utils(underflow_sub_seq)

    function new(string name="underflow_sub_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 0401
        write_byte(8'h01);
        write_byte(8'h04);

        // Operand B = 0400
        write_byte(8'h00);
        write_byte(8'h04);

        // Start SUB
        send_cycle(8'h0C, 8'h00);
        send_cycle(8'h0C, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();  // Expected low byte = 00
        read_byte();  // Expected high byte = 00

    endtask

endclass

class max_normal_exponent_add_seq extends uvm_sequence #(trans);

    `uvm_object_utils(max_normal_exponent_add_seq)

    function new(string name="max_normal_exponent_add_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 77FF
        write_byte(8'hFF);
        write_byte(8'h77);

        // Operand B = 77FF
        write_byte(8'hFF);
        write_byte(8'h77);

        // Start ADD
        send_cycle(8'h04, 8'h00);
        send_cycle(8'h04, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result
        read_byte();
        read_byte();

    endtask

endclass

class leading_zero_sub_seq extends uvm_sequence #(trans);

    `uvm_object_utils(leading_zero_sub_seq)

    function new(string name="leading_zero_sub_seq");
        super.new(name);
    endfunction

    task send_cycle(bit [7:0] control, bit [7:0] data);
        trans req;

        req = trans::type_id::create("req");
        start_item(req);
        req.ui_in  = control;
        req.uio_in = data;
        finish_item(req);
    endtask

    task write_byte(bit [7:0] data);
        send_cycle(8'h01, data);
        send_cycle(8'h01, data);
        send_cycle(8'h00, data);
        send_cycle(8'h00, 8'h00);
    endtask

    task read_byte();
        send_cycle(8'h02, 8'h00);
        send_cycle(8'h02, 8'h00);
        repeat(3)
            send_cycle(8'h00, 8'h00);
    endtask

    task body();

        // Initial idle
        repeat(5)
            send_cycle(8'h00, 8'h00);

        // Operand A = 4000 (2.0)
        write_byte(8'h00);
        write_byte(8'h40);

        // Operand B = 3E00 (1.5)
        write_byte(8'h00);
        write_byte(8'h3E);

        // Start SUB
        send_cycle(8'h0C, 8'h00);
        send_cycle(8'h0C, 8'h00);

        // Wait for completion
        repeat(12)
            send_cycle(8'h00, 8'h00);

        // Read result = 3800
        read_byte();  // Low byte = 00
        read_byte();  // High byte = 38

    endtask

endclass*/
