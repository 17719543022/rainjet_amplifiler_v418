`timescale 1 ns / 1 ps
module compact_usb_8121m5 (
    input               clk,
    input               sw0,
    input               sw1,

    //USB INTERFACE
    inout   [15:0]      USB_DATA,
    output              USB_IFCLK,
    output              SLV_WR,
    output              SLV_RD,
    output              SLV_OE,
    output              SLV_CS,
    output              SLV_ADD0,
    output              SLV_ADD1,
    input               SLV_FLAGA,
    input               SLV_FLAGB,
    output              SLV_RST,

    output reg [2:0]    led,

    output              ad7177_cs,
    output              ad7177_sck,
    output              ad7177_din,
    output              ad7177_sync,

    input               ad7177_dout_18,
    input               ad7177_dout_17,
    input               ad7177_dout_16,
    input               ad7177_dout_15,
    input               ad7177_dout_14,
    input               ad7177_dout_13,
    input               ad7177_dout_12,
    input               ad7177_dout_11,
    input               ad7177_dout_10,
    input               ad7177_dout_9,

    input               ad7177_dout_8,
    input               ad7177_dout_7,
    input               ad7177_dout_6,
    input               ad7177_dout_5,
    input               ad7177_dout_4,
    input               ad7177_dout_3,
    input               ad7177_dout_2,
    input               ad7177_dout_1,
    input               ad7177_dout_0,

    /******************* digital output serialy *********************/
    output              FPGA_DOUT_OE,
    output              FPGA_DOUT_LCK,
    output              FPGA_DOUT_RST,
    output              FPGA_DOUT_SCK,
    output              FPGA_DOUT_SIN,

    //UART
    input               uart_rxd,
    output              uart_txd,

    //EEPROM
    output              scl_eeprom,
    inout               sda_eeprom,
    
    //BATARRY
    output              batarry_scl,
    inout               batarry_sda,
    input               batarry_sta1,
    input               batarry_sta2,
    output              batarry_led_red,
    output              batarry_led_green,
    output              batarry_led_blue,
    
    input               supply_key,
    output              supply_out,

    output              jl_com1_cs_out,
    output              jl_com1_sck_out,
    output              jl_com1_data_out0,
    output              jl_com1_data_out1,
    input               jl_com1_cs_in,
    input               jl_com1_sck_in,
    input               jl_com1_data_in0,
    input               jl_com1_data_in1,

    output              jl_com2_cs_out,
    output              jl_com2_sck_out,
    output              jl_com2_data_out0,
    output              jl_com2_data_out1,
    input               jl_com2_cs_in,
    input               jl_com2_sck_in,
    input               jl_com2_data_in0,
    input               jl_com2_data_in1,

    output              jl_com3_cs_out,
    output              jl_com3_sck_out,
    output              jl_com3_data_out0,
    output              jl_com3_data_out1,
    input               jl_com3_cs_in,
    input               jl_com3_sck_in,
    input               jl_com3_data_in0,
    input               jl_com3_data_in1
);

parameter  MAIN_CLK_FREQ          = 48000000;

wire             rst_n;

wire    [15:0]   adc_sample_period;
wire    [2:0]    adc_trigger_mode;
wire    [2:0]    adc_trigger_source;
wire    [31:0]   adc_trigger_delay;
wire    [31:0]   adc_trigger_length;
wire    [11:0]   adc_trigger_level;
wire             adc_sample_en_usb;

wire             adc_wren;
wire    [31:0]   adc_data;

reg              fifo_2_usb_wren;
wire             fifo_2_usb_full;
wire             fifo_2_usb_empty;
wire    [31:0]   fifo_2_usb_q;
wire    [15:0]   fifo_2_usb_usedw;
wire             fifo_2_usb_rdreq_usb;

wire             adc_record_wren;
wire    [31:0]   adc_record_wdata;      

wire [ 7:0]      uart_trig_data;

wire [127:0]     usb_cfg_bus;
wire             usb_cfg_valid;
wire             usb_trigger_value_valid;

wire             usb_impedance_valid;
wire [31:0]      real_max_value_1;
wire [31:0]      real_max_value_2;
wire [31:0]      real_max_value_3;
wire [31:0]      real_max_value_4;
wire [31:0]      real_max_value_5;
wire [31:0]      real_max_value_6;
wire [31:0]      real_max_value_7;
wire [31:0]      real_max_value_8;
wire [31:0]      real_max_value_9;
wire [31:0]      real_max_value_10;
wire [31:0]      real_max_value_11;
wire [31:0]      real_max_value_12;
wire [31:0]      real_max_value_13;
wire [31:0]      real_max_value_14;
wire [31:0]      real_max_value_15;
wire [31:0]      real_max_value_16;
wire [31:0]      real_max_value_17;
wire [31:0]      real_max_value_18;
wire [31:0]      real_max_value_19;
wire [31:0]      real_max_value_20;
wire [31:0]      real_max_value_21;
wire [31:0]      real_max_value_22;
wire [31:0]      real_max_value_23;
wire [31:0]      real_max_value_24;
wire [31:0]      real_max_value_25;
wire [31:0]      real_max_value_26;
wire [31:0]      real_max_value_27;
wire [31:0]      real_max_value_28;
wire [31:0]      real_max_value_29;
wire [31:0]      real_max_value_30;
wire [31:0]      real_max_value_31;
wire [31:0]      real_max_value_32;
wire [31:0]      real_max_value_33;
wire [31:0]      real_max_value_34;
wire [31:0]      real_max_value_35;
wire [31:0]      real_max_value_36;
wire [31:0]      real_max_value_37;
wire [31:0]      real_max_value_38;
wire [31:0]      real_max_value_39;
wire [31:0]      real_max_value_40;
wire [31:0]      real_max_value_41;
wire [31:0]      real_max_value_42;
wire [31:0]      real_max_value_43;
wire [31:0]      real_max_value_44;
wire [31:0]      real_max_value_45;
wire [31:0]      real_max_value_46;
wire [31:0]      real_max_value_47;
wire [31:0]      real_max_value_48;
wire [31:0]      real_max_value_49;
wire [31:0]      real_max_value_50;
wire [31:0]      real_max_value_51;
wire [31:0]      real_max_value_52;
wire [31:0]      real_max_value_53;
wire [31:0]      real_max_value_54;
wire [31:0]      real_max_value_55;
wire [31:0]      real_max_value_56;
wire [31:0]      real_max_value_57;
wire [31:0]      real_max_value_58;
wire [31:0]      real_max_value_59;
wire [31:0]      real_max_value_60;
wire [31:0]      real_max_value_61;
wire [31:0]      real_max_value_62;
wire [31:0]      real_max_value_63;
wire [31:0]      real_max_value_64;
wire [31:0]      real_max_value_65;
wire [31:0]      real_max_value_66;
wire [31:0]      real_max_value_67;
wire [31:0]      real_max_value_68;
wire [31:0]      real_max_value_69;
wire [31:0]      real_max_value_70;
wire [31:0]      real_max_value_71;
wire [31:0]      real_max_value_72;
wire [31:0]      real_max_value_73;
wire [31:0]      real_max_value_74;
wire [31:0]      real_max_value_75;
wire [31:0]      real_max_value_76;
wire [31:0]      real_max_value_77;
wire [31:0]      real_max_value_78;
wire [31:0]      real_max_value_79;
wire [31:0]      real_max_value_80;
wire [31:0]      real_max_value_81;
wire [31:0]      real_max_value_82;
wire [31:0]      real_max_value_83;
wire [31:0]      real_max_value_84;
wire [31:0]      real_max_value_85;
wire [31:0]      real_max_value_86;
wire [31:0]      real_max_value_87;
wire [31:0]      real_max_value_88;
wire [31:0]      real_max_value_89;
wire [31:0]      real_max_value_90;
wire [31:0]      real_max_value_91;
wire [31:0]      real_max_value_92;
wire [31:0]      real_max_value_93;
wire [31:0]      real_max_value_94;
wire [31:0]      real_max_value_95;
wire [31:0]      real_max_value_96;
wire [31:0]      real_max_value_97;
wire [31:0]      real_max_value_98;
wire [31:0]      real_max_value_99;
wire [31:0]      real_max_value_100;
wire [31:0]      real_max_value_101;
wire [31:0]      real_max_value_102;
wire [31:0]      real_max_value_103;
wire [31:0]      real_max_value_104;
wire [31:0]      real_max_value_105;
wire [31:0]      real_max_value_106;
wire [31:0]      real_max_value_107;
wire [31:0]      real_max_value_108;
wire [31:0]      real_max_value_109;
wire [31:0]      real_max_value_110;
wire [31:0]      real_max_value_111;
wire [31:0]      real_max_value_112;
wire [31:0]      real_max_value_113;
wire [31:0]      real_max_value_114;
wire [31:0]      real_max_value_115;
wire [31:0]      real_max_value_116;
wire [31:0]      real_max_value_117;
wire [31:0]      real_max_value_118;
wire [31:0]      real_max_value_119;
wire [31:0]      real_max_value_120;
wire [31:0]      real_max_value_121;
wire [31:0]      real_max_value_122;
wire [31:0]      real_max_value_123;
wire [31:0]      real_max_value_124;
wire [31:0]      real_max_value_125;
wire [31:0]      real_max_value_126;
wire [31:0]      real_max_value_127;
wire [31:0]      real_max_value_128;
wire [31:0]      real_max_value_129;
wire [31:0]      real_max_value_130;
wire [31:0]      real_max_value_131;
wire [31:0]      real_max_value_132;
wire [31:0]      real_max_value_133;
wire [31:0]      real_max_value_134;
wire [31:0]      real_max_value_135;
wire [31:0]      real_max_value_136;
wire [31:0]      real_max_value_137;
wire [31:0]      real_max_value_138;
wire [31:0]      real_max_value_139;
wire [31:0]      real_max_value_140;
wire [31:0]      real_max_value_141;
wire [31:0]      real_max_value_142;
wire [31:0]      real_max_value_143;
wire [31:0]      real_max_value_144;

reg  [15:0]      sw0_shift;
reg  [15:0]      sw1_shift;
reg              sw0_d;
reg              sw1_d;

wire             jl_cs_out;
wire             jl_sck_out;
wire             jl_data_out0;
wire             jl_data_out1;
wire             jl_cs_in;
wire             jl_sck_in;
wire             jl_data_in0;
wire             jl_data_in1;

assign jl_com1_cs_out    = ((sw1_d & sw0_d) | ((~sw1_d) & (~sw0_d))) ? jl_cs_out    : 1'b0;
assign jl_com1_sck_out   = ((sw1_d & sw0_d) | ((~sw1_d) & (~sw0_d))) ? jl_sck_out   : 1'b0;
assign jl_com1_data_out0 = ((sw1_d & sw0_d) | ((~sw1_d) & (~sw0_d))) ? jl_data_out0 : 1'b0;
assign jl_com1_data_out1 = ((sw1_d & sw0_d) | ((~sw1_d) & (~sw0_d))) ? jl_data_out1 : 1'b0;

assign jl_com2_cs_out    = ((sw1_d & sw0_d) | ((~sw1_d) & sw0_d))    ? jl_cs_out    : 1'b0;
assign jl_com2_sck_out   = ((sw1_d & sw0_d) | ((~sw1_d) & sw0_d))    ? jl_sck_out   : 1'b0;
assign jl_com2_data_out0 = ((sw1_d & sw0_d) | ((~sw1_d) & sw0_d))    ? jl_data_out0 : 1'b0;
assign jl_com2_data_out1 = ((sw1_d & sw0_d) | ((~sw1_d) & sw0_d))    ? jl_data_out1 : 1'b0;

assign jl_com3_cs_out    = ((sw1_d & sw0_d) | (sw1_d & (~sw0_d)))    ? jl_cs_out    : 1'b0;
assign jl_com3_sck_out   = ((sw1_d & sw0_d) | (sw1_d & (~sw0_d)))    ? jl_sck_out   : 1'b0;
assign jl_com3_data_out0 = ((sw1_d & sw0_d) | (sw1_d & (~sw0_d)))    ? jl_data_out0 : 1'b0;
assign jl_com3_data_out1 = ((sw1_d & sw0_d) | (sw1_d & (~sw0_d)))    ? jl_data_out1 : 1'b0;

always @(posedge clk)
begin
    sw0_shift <= {sw0_shift[14:0], sw0};
    sw1_shift <= {sw1_shift[14:0], sw1};
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        sw0_d <= 1'b1;
    else if (&sw0_shift)
        sw0_d <= 1'b1;
    else if (~|sw0_shift)
        sw0_d <= 1'b0;
    else
        sw0_d <= sw0_d;
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        sw1_d <= 1'b1;
    else if (&sw1_shift)
        sw1_d <= 1'b1;
    else if (~|sw1_shift)
        sw1_d <= 1'b0;
    else
        sw1_d <= sw1_d;
end

rst_ctrl rst_ctrl (
    .rst_i                          (1'b1                   ),
    .isp_rst                        (1'b1                   ),
    .clk                            (clk                    ),
    .power_up_rst                   (rst_n                  ),
    .rst_o                          (                       )
);

reg  [31:0]     led_switch_counter;
reg             i2c_read_trigger;

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        led_switch_counter <= 32'd0;
    else if (led_switch_counter == (MAIN_CLK_FREQ - 1))
        led_switch_counter <= 32'd0;
    else
        led_switch_counter <= led_switch_counter + 32'd1;
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        led <= 3'd7;
    else if (adc_initiate_complete & (~adc_sample_en_usb) & (~adc_sample_en_slave))
        led <= 3'd0;
    else if (adc_initiate_complete & (adc_sample_en_usb | adc_sample_en_slave) & (led_switch_counter == 32'd1))
        led <= 3'd7;
    else if (adc_initiate_complete & (adc_sample_en_usb | adc_sample_en_slave) & (led_switch_counter == MAIN_CLK_FREQ / 2 - 1))
        led <= 3'd0;
    else
        led <= led;
end

always @(posedge clk)
begin
    if (~rst_n)
        i2c_read_trigger <= 1'b0;
    else if ((led_switch_counter == MAIN_CLK_FREQ / 2 - 1) | (led_switch_counter == MAIN_CLK_FREQ - 1))
        i2c_read_trigger <= 1'b1;
    else
        i2c_read_trigger <= 1'b0;
end

wire [15:0]             USB_DATA_OUT;
wire [15:0]             USB_DATA_IN;
wire                    i2c_byte_out_en;
wire [ 7:0]             i2c_byte_out;

wire [15:0]             batarry_protocol_volt;
wire [15:0]             batarry_protocol_stat;

usb_68013_ctrl usb_68013_ctrl (
    .clk                            (clk                    ),
    .rst_n                          (rst_n                  ),

    .USB_IFCLK                      (USB_IFCLK              ),
    .SLV_WR                         (SLV_WR                 ),
    .SLV_RD                         (SLV_RD                 ),
    .SLV_OE                         (SLV_OE                 ),
    .SLV_CS                         (SLV_CS                 ),
    .SLV_ADD0                       (SLV_ADD0               ),
    .SLV_ADD1                       (SLV_ADD1               ),
    .SLV_FLAGA                      (SLV_FLAGA              ),
    .SLV_FLAGB                      (SLV_FLAGB              ),
    .SLV_RST                        (SLV_RST                ),

    .USB_DATA_OUT                   (USB_DATA_OUT           ),
    .USB_DATA_IN                    (USB_DATA_IN            ),

    .adc_sample_period              (adc_sample_period      ),
    .adc_trigger_mode               (adc_trigger_mode       ),
    .adc_trigger_source             (adc_trigger_source     ),
    .adc_trigger_delay              (adc_trigger_delay      ),
    .adc_trigger_length             (adc_trigger_length     ),
    .adc_trigger_level              (adc_trigger_level      ),
    .adc_sample_en_usb              (adc_sample_en_usb      ),

    .adc_initiate_complete          (adc_initiate_complete  ),
    .i2c_byte_out_en                (i2c_byte_out_en        ),
    .i2c_byte_out                   (i2c_byte_out           ),
    .batarry_protocol               ({batarry_protocol_stat, batarry_protocol_volt}),
    .fifo_2_usb_empty               (fifo_2_usb_empty       ),
    .USB_WR_DATA_ADC                (fifo_2_usb_q           ),
    .fifo_2_usb_usedw               (fifo_2_usb_usedw       ),
    .fifo_2_usb_rdreq_usb           (fifo_2_usb_rdreq_usb   ),

    .usb_cfg_bus                    (usb_cfg_bus            ),
    .usb_cfg_valid                  (usb_cfg_valid          ),
    .usb_trigger_value_valid        (usb_trigger_value_valid),
    .usb_impedance_valid            (usb_impedance_valid    ),
    .real_max_value_1               (real_max_value_1       ),
    .real_max_value_2               (real_max_value_2       ),
    .real_max_value_3               (real_max_value_3       ),
    .real_max_value_4               (real_max_value_4       ),
    .real_max_value_5               (real_max_value_5       ),
    .real_max_value_6               (real_max_value_6       ),
    .real_max_value_7               (real_max_value_7       ),
    .real_max_value_8               (real_max_value_8       ),
    .real_max_value_9               (real_max_value_9       ),
    .real_max_value_10              (real_max_value_10      ),
    .real_max_value_11              (real_max_value_11      ),
    .real_max_value_12              (real_max_value_12      ),
    .real_max_value_13              (real_max_value_13      ),
    .real_max_value_14              (real_max_value_14      ),
    .real_max_value_15              (real_max_value_15      ),
    .real_max_value_16              (real_max_value_16      ),
    .real_max_value_17              (real_max_value_17      ),
    .real_max_value_18              (real_max_value_18      ),
    .real_max_value_19              (real_max_value_19      ),
    .real_max_value_20              (real_max_value_20      ),
    .real_max_value_21              (real_max_value_21      ),
    .real_max_value_22              (real_max_value_22      ),
    .real_max_value_23              (real_max_value_23      ),
    .real_max_value_24              (real_max_value_24      ),
    .real_max_value_25              (real_max_value_25      ),
    .real_max_value_26              (real_max_value_26      ),
    .real_max_value_27              (real_max_value_27      ),
    .real_max_value_28              (real_max_value_28      ),
    .real_max_value_29              (real_max_value_29      ),
    .real_max_value_30              (real_max_value_30      ),
    .real_max_value_31              (real_max_value_31      ),
    .real_max_value_32              (real_max_value_32      ),
    .real_max_value_33              (real_max_value_33      ),
    .real_max_value_34              (real_max_value_34      ),
    .real_max_value_35              (real_max_value_35      ),
    .real_max_value_36              (real_max_value_36      ),
    .real_max_value_37              (real_max_value_37      ),
    .real_max_value_38              (real_max_value_38      ),
    .real_max_value_39              (real_max_value_39      ),
    .real_max_value_40              (real_max_value_40      ),
    .real_max_value_41              (real_max_value_41      ),
    .real_max_value_42              (real_max_value_42      ),
    .real_max_value_43              (real_max_value_43      ),
    .real_max_value_44              (real_max_value_44      ),
    .real_max_value_45              (real_max_value_45      ),
    .real_max_value_46              (real_max_value_46      ),
    .real_max_value_47              (real_max_value_47      ),
    .real_max_value_48              (real_max_value_48      ),
    .real_max_value_49              (real_max_value_49      ),
    .real_max_value_50              (real_max_value_50      ),
    .real_max_value_51              (real_max_value_51      ),
    .real_max_value_52              (real_max_value_52      ),
    .real_max_value_53              (real_max_value_53      ),
    .real_max_value_54              (real_max_value_54      ),
    .real_max_value_55              (real_max_value_55      ),
    .real_max_value_56              (real_max_value_56      ),
    .real_max_value_57              (real_max_value_57      ),
    .real_max_value_58              (real_max_value_58      ),
    .real_max_value_59              (real_max_value_59      ),
    .real_max_value_60              (real_max_value_60      ),
    .real_max_value_61              (real_max_value_61      ),
    .real_max_value_62              (real_max_value_62      ),
    .real_max_value_63              (real_max_value_63      ),
    .real_max_value_64              (real_max_value_64      ),
    .real_max_value_65              (real_max_value_65      ),
    .real_max_value_66              (real_max_value_66      ),
    .real_max_value_67              (real_max_value_67      ),
    .real_max_value_68              (real_max_value_68      ),
    .real_max_value_69              (real_max_value_69      ),
    .real_max_value_70              (real_max_value_70      ),
    .real_max_value_71              (real_max_value_71      ),
    .real_max_value_72              (real_max_value_72      ),
    .real_max_value_73              (real_max_value_73      ),
    .real_max_value_74              (real_max_value_74      ),
    .real_max_value_75              (real_max_value_75      ),
    .real_max_value_76              (real_max_value_76      ),
    .real_max_value_77              (real_max_value_77      ),
    .real_max_value_78              (real_max_value_78      ),
    .real_max_value_79              (real_max_value_79      ),
    .real_max_value_80              (real_max_value_80      ),
    .real_max_value_81              (real_max_value_81      ),
    .real_max_value_82              (real_max_value_82      ),
    .real_max_value_83              (real_max_value_83      ),
    .real_max_value_84              (real_max_value_84      ),
    .real_max_value_85              (real_max_value_85      ),
    .real_max_value_86              (real_max_value_86      ),
    .real_max_value_87              (real_max_value_87      ),
    .real_max_value_88              (real_max_value_88      ),
    .real_max_value_89              (real_max_value_89      ),
    .real_max_value_90              (real_max_value_90      ),
    .real_max_value_91              (real_max_value_91      ),
    .real_max_value_92              (real_max_value_92      ),
    .real_max_value_93              (real_max_value_93      ),
    .real_max_value_94              (real_max_value_94      ),
    .real_max_value_95              (real_max_value_95      ),
    .real_max_value_96              (real_max_value_96      ),
    .real_max_value_97              (real_max_value_97      ),
    .real_max_value_98              (real_max_value_98      ),
    .real_max_value_99              (real_max_value_99      ),
    .real_max_value_100             (real_max_value_100     ),
    .real_max_value_101             (real_max_value_101     ),
    .real_max_value_102             (real_max_value_102     ),
    .real_max_value_103             (real_max_value_103     ),
    .real_max_value_104             (real_max_value_104     ),
    .real_max_value_105             (real_max_value_105     ),
    .real_max_value_106             (real_max_value_106     ),
    .real_max_value_107             (real_max_value_107     ),
    .real_max_value_108             (real_max_value_108     ),
    .real_max_value_109             (real_max_value_109     ),
    .real_max_value_110             (real_max_value_110     ),
    .real_max_value_111             (real_max_value_111     ),
    .real_max_value_112             (real_max_value_112     ),
    .real_max_value_113             (real_max_value_113     ),
    .real_max_value_114             (real_max_value_114     ),
    .real_max_value_115             (real_max_value_115     ),
    .real_max_value_116             (real_max_value_116     ),
    .real_max_value_117             (real_max_value_117     ),
    .real_max_value_118             (real_max_value_118     ),
    .real_max_value_119             (real_max_value_119     ),
    .real_max_value_120             (real_max_value_120     ),
    .real_max_value_121             (real_max_value_121     ),
    .real_max_value_122             (real_max_value_122     ),
    .real_max_value_123             (real_max_value_123     ),
    .real_max_value_124             (real_max_value_124     ),
    .real_max_value_125             (real_max_value_125     ),
    .real_max_value_126             (real_max_value_126     ),
    .real_max_value_127             (real_max_value_127     ),
    .real_max_value_128             (real_max_value_128     ),
    .real_max_value_129             (real_max_value_129     ),
    .real_max_value_130             (real_max_value_130     ),
    .real_max_value_131             (real_max_value_131     ),
    .real_max_value_132             (real_max_value_132     ),
    .real_max_value_133             (real_max_value_133     ),
    .real_max_value_134             (real_max_value_134     ),
    .real_max_value_135             (real_max_value_135     ),
    .real_max_value_136             (real_max_value_136     ),
    .real_max_value_137             (real_max_value_137     ),
    .real_max_value_138             (real_max_value_138     ),
    .real_max_value_139             (real_max_value_139     ),
    .real_max_value_140             (real_max_value_140     ),
    .real_max_value_141             (real_max_value_141     ),
    .real_max_value_142             (real_max_value_142     ),
    .real_max_value_143             (real_max_value_143     ),
    .real_max_value_144             (real_max_value_144     )
);

assign USB_DATA = SLV_OE ? USB_DATA_OUT : 16'bzzzzzzzzzzzzzzzz;
assign USB_DATA_IN = USB_DATA;

always @(posedge clk)
if ((~rst_n) | (~adc_sample_en_usb))
    fifo_2_usb_wren <= 1'b0;
else if (result_write_trigger)
    fifo_2_usb_wren <= ((fifo_2_usb_usedw >= 16'd65280) | fifo_2_usb_full) ? 1'b0 : 1'b1;
else
    fifo_2_usb_wren <= fifo_2_usb_wren;

fifo_generator_0 fifo_2_usb (
    .clk                            (clk                    ), // input wire clk
    .rst                            ((~rst_n) | (~adc_sample_en_usb)), // input wire rst
    .din                            (adc_data               ), // input wire [31 : 0] din
    .wr_en                          (adc_wren & fifo_2_usb_wren), // input wire wr_en
    .rd_en                          (fifo_2_usb_rdreq_usb & (~fifo_2_usb_empty)), // input wire rd_en
    .dout                           (fifo_2_usb_q           ), // output wire [31 : 0] dout
    .full                           (fifo_2_usb_full        ), // output wire full
    .empty                          (fifo_2_usb_empty       ), // output wire empty
    .data_count                     (fifo_2_usb_usedw       ), // output wire [15 : 0] data_count
    .wr_rst_busy                    (                       ), // output wire wr_rst_busy
    .rd_rst_busy                    (                       )  // output wire rd_rst_busy
);

filter_rxd filter_com1_cs_in (.clk(clk), .pin_in(jl_com1_cs_in   ), .filtered_out(jl_com1_cs_in_fil   ));
filter_rxd filter_com1_sck_in(.clk(clk), .pin_in(jl_com1_sck_in  ), .filtered_out(jl_com1_sck_in_fil  ));
filter_rxd filter_com1_di0_in(.clk(clk), .pin_in(jl_com1_data_in0), .filtered_out(jl_com1_data_in0_fil));
filter_rxd filter_com1_di1_in(.clk(clk), .pin_in(jl_com1_data_in1), .filtered_out(jl_com1_data_in1_fil));
filter_rxd filter_com2_cs_in (.clk(clk), .pin_in(jl_com2_cs_in   ), .filtered_out(jl_com2_cs_in_fil   ));
filter_rxd filter_com2_sck_in(.clk(clk), .pin_in(jl_com2_sck_in  ), .filtered_out(jl_com2_sck_in_fil  ));
filter_rxd filter_com2_di0_in(.clk(clk), .pin_in(jl_com2_data_in0), .filtered_out(jl_com2_data_in0_fil));
filter_rxd filter_com2_di1_in(.clk(clk), .pin_in(jl_com2_data_in1), .filtered_out(jl_com2_data_in1_fil));
filter_rxd filter_com3_cs_in (.clk(clk), .pin_in(jl_com3_cs_in   ), .filtered_out(jl_com3_cs_in_fil   ));
filter_rxd filter_com3_sck_in(.clk(clk), .pin_in(jl_com3_sck_in  ), .filtered_out(jl_com3_sck_in_fil  ));
filter_rxd filter_com3_di0_in(.clk(clk), .pin_in(jl_com3_data_in0), .filtered_out(jl_com3_data_in0_fil));
filter_rxd filter_com3_di1_in(.clk(clk), .pin_in(jl_com3_data_in1), .filtered_out(jl_com3_data_in1_fil));
  
adc_7177_ctrl adc_7177_ctrl (
    .clk                            (clk                    ),
    .rst_n                          (rst_n                  ),

    .ad7177_cs                      (ad7177_cs              ),
    .ad7177_sck                     (ad7177_sck             ),
    .ad7177_din                     (ad7177_din             ),
    .ad7177_sync                    (ad7177_sync            ),

    .ad7177_dout_18                 (ad7177_dout_18         ),
    .ad7177_dout_17                 (ad7177_dout_17         ),
    .ad7177_dout_16                 (ad7177_dout_16         ),
    .ad7177_dout_15                 (ad7177_dout_15         ),
    .ad7177_dout_14                 (ad7177_dout_14         ),
    .ad7177_dout_13                 (ad7177_dout_13         ),
    .ad7177_dout_12                 (ad7177_dout_12         ),
    .ad7177_dout_11                 (ad7177_dout_11         ),
    .ad7177_dout_10                 (ad7177_dout_10         ),
    .ad7177_dout_9                  (ad7177_dout_9          ),
    .ad7177_dout_8                  (ad7177_dout_8          ),
    .ad7177_dout_7                  (ad7177_dout_7          ),
    .ad7177_dout_6                  (ad7177_dout_6          ),
    .ad7177_dout_5                  (ad7177_dout_5          ),
    .ad7177_dout_4                  (ad7177_dout_4          ),
    .ad7177_dout_3                  (ad7177_dout_3          ),
    .ad7177_dout_2                  (ad7177_dout_2          ),
    .ad7177_dout_1                  (ad7177_dout_1          ),
    .ad7177_dout_0                  (ad7177_dout_0          ),

    .adc_trigger_length_usb         (adc_trigger_length     ),
    .adc_sample_en_usb              (adc_sample_en_usb      ),
    .adc_sample_en_slave            (adc_sample_en_slave    ),

    .adc_initiate_complete          (adc_initiate_complete  ),
    .result_write_trigger           (result_write_trigger   ),
    .adc_wren                       (adc_wren               ),
    .adc_data                       (adc_data               ),

    .usb_trigger_value              (usb_cfg_bus[71:64]     ),
    .usb_trigger_value_valid        (usb_trigger_value_valid),
    .usb_impedance_valid            (usb_impedance_valid    ),
    .usb_cfg_bus_usb                (usb_cfg_bus[15:0]      ),
    .usb_sample_period              (usb_cfg_bus[127:96]    ),
    .usb_cfg_valid_usb              (usb_cfg_valid          ),
    .uart_trig_data                 (uart_trig_data         ),
    .uart_ri                        (uart_ri                ),

    .sw0_d                          (sw0_d                  ),
    .sw1_d                          (sw1_d                  ),

    .jl_cs_out                      (jl_cs_out              ),
    .jl_sck_out                     (jl_sck_out             ),
    .jl_data_out0                   (jl_data_out0           ),
    .jl_data_out1                   (jl_data_out1           ),
    .jl_com1_cs_in                  (jl_com1_cs_in_fil      ),
    .jl_com1_sck_in                 (jl_com1_sck_in_fil     ),
    .jl_com1_data_in0               (jl_com1_data_in0_fil   ),
    .jl_com1_data_in1               (jl_com1_data_in1_fil   ),
    .jl_com2_cs_in                  (jl_com2_cs_in_fil      ),
    .jl_com2_sck_in                 (jl_com2_sck_in_fil     ),
    .jl_com2_data_in0               (jl_com2_data_in0_fil   ),
    .jl_com2_data_in1               (jl_com2_data_in1_fil   ),
    .jl_com3_cs_in                  (jl_com3_cs_in_fil      ),
    .jl_com3_sck_in                 (jl_com3_sck_in_fil     ),
    .jl_com3_data_in0               (jl_com3_data_in0_fil   ),
    .jl_com3_data_in1               (jl_com3_data_in1_fil   ),

    .FPGA_DOUT_OE                   (FPGA_DOUT_OE           ),
    .FPGA_DOUT_LCK                  (FPGA_DOUT_LCK          ),
    .FPGA_DOUT_RST                  (FPGA_DOUT_RST          ),
    .FPGA_DOUT_SCK                  (FPGA_DOUT_SCK          ),
    .FPGA_DOUT_SIN                  (FPGA_DOUT_SIN          ),
    .real_max_value_1               (real_max_value_1       ),
    .real_max_value_2               (real_max_value_2       ),
    .real_max_value_3               (real_max_value_3       ),
    .real_max_value_4               (real_max_value_4       ),
    .real_max_value_5               (real_max_value_5       ),
    .real_max_value_6               (real_max_value_6       ),
    .real_max_value_7               (real_max_value_7       ),
    .real_max_value_8               (real_max_value_8       ),
    .real_max_value_9               (real_max_value_9       ),
    .real_max_value_10              (real_max_value_10      ),
    .real_max_value_11              (real_max_value_11      ),
    .real_max_value_12              (real_max_value_12      ),
    .real_max_value_13              (real_max_value_13      ),
    .real_max_value_14              (real_max_value_14      ),
    .real_max_value_15              (real_max_value_15      ),
    .real_max_value_16              (real_max_value_16      ),
    .real_max_value_17              (real_max_value_17      ),
    .real_max_value_18              (real_max_value_18      ),
    .real_max_value_19              (real_max_value_19      ),
    .real_max_value_20              (real_max_value_20      ),
    .real_max_value_21              (real_max_value_21      ),
    .real_max_value_22              (real_max_value_22      ),
    .real_max_value_23              (real_max_value_23      ),
    .real_max_value_24              (real_max_value_24      ),
    .real_max_value_25              (real_max_value_25      ),
    .real_max_value_26              (real_max_value_26      ),
    .real_max_value_27              (real_max_value_27      ),
    .real_max_value_28              (real_max_value_28      ),
    .real_max_value_29              (real_max_value_29      ),
    .real_max_value_30              (real_max_value_30      ),
    .real_max_value_31              (real_max_value_31      ),
    .real_max_value_32              (real_max_value_32      ),
    .real_max_value_33              (real_max_value_33      ),
    .real_max_value_34              (real_max_value_34      ),
    .real_max_value_35              (real_max_value_35      ),
    .real_max_value_36              (real_max_value_36      ),
    .real_max_value_37              (real_max_value_37      ),
    .real_max_value_38              (real_max_value_38      ),
    .real_max_value_39              (real_max_value_39      ),
    .real_max_value_40              (real_max_value_40      ),
    .real_max_value_41              (real_max_value_41      ),
    .real_max_value_42              (real_max_value_42      ),
    .real_max_value_43              (real_max_value_43      ),
    .real_max_value_44              (real_max_value_44      ),
    .real_max_value_45              (real_max_value_45      ),
    .real_max_value_46              (real_max_value_46      ),
    .real_max_value_47              (real_max_value_47      ),
    .real_max_value_48              (real_max_value_48      ),
    .real_max_value_49              (real_max_value_49      ),
    .real_max_value_50              (real_max_value_50      ),
    .real_max_value_51              (real_max_value_51      ),
    .real_max_value_52              (real_max_value_52      ),
    .real_max_value_53              (real_max_value_53      ),
    .real_max_value_54              (real_max_value_54      ),
    .real_max_value_55              (real_max_value_55      ),
    .real_max_value_56              (real_max_value_56      ),
    .real_max_value_57              (real_max_value_57      ),
    .real_max_value_58              (real_max_value_58      ),
    .real_max_value_59              (real_max_value_59      ),
    .real_max_value_60              (real_max_value_60      ),
    .real_max_value_61              (real_max_value_61      ),
    .real_max_value_62              (real_max_value_62      ),
    .real_max_value_63              (real_max_value_63      ),
    .real_max_value_64              (real_max_value_64      ),
    .real_max_value_65              (real_max_value_65      ),
    .real_max_value_66              (real_max_value_66      ),
    .real_max_value_67              (real_max_value_67      ),
    .real_max_value_68              (real_max_value_68      ),
    .real_max_value_69              (real_max_value_69      ),
    .real_max_value_70              (real_max_value_70      ),
    .real_max_value_71              (real_max_value_71      ),
    .real_max_value_72              (real_max_value_72      ),
    .real_max_value_73              (real_max_value_73      ),
    .real_max_value_74              (real_max_value_74      ),
    .real_max_value_75              (real_max_value_75      ),
    .real_max_value_76              (real_max_value_76      ),
    .real_max_value_77              (real_max_value_77      ),
    .real_max_value_78              (real_max_value_78      ),
    .real_max_value_79              (real_max_value_79      ),
    .real_max_value_80              (real_max_value_80      ),
    .real_max_value_81              (real_max_value_81      ),
    .real_max_value_82              (real_max_value_82      ),
    .real_max_value_83              (real_max_value_83      ),
    .real_max_value_84              (real_max_value_84      ),
    .real_max_value_85              (real_max_value_85      ),
    .real_max_value_86              (real_max_value_86      ),
    .real_max_value_87              (real_max_value_87      ),
    .real_max_value_88              (real_max_value_88      ),
    .real_max_value_89              (real_max_value_89      ),
    .real_max_value_90              (real_max_value_90      ),
    .real_max_value_91              (real_max_value_91      ),
    .real_max_value_92              (real_max_value_92      ),
    .real_max_value_93              (real_max_value_93      ),
    .real_max_value_94              (real_max_value_94      ),
    .real_max_value_95              (real_max_value_95      ),
    .real_max_value_96              (real_max_value_96      ),
    .real_max_value_97              (real_max_value_97      ),
    .real_max_value_98              (real_max_value_98      ),
    .real_max_value_99              (real_max_value_99      ),
    .real_max_value_100             (real_max_value_100     ),
    .real_max_value_101             (real_max_value_101     ),
    .real_max_value_102             (real_max_value_102     ),
    .real_max_value_103             (real_max_value_103     ),
    .real_max_value_104             (real_max_value_104     ),
    .real_max_value_105             (real_max_value_105     ),
    .real_max_value_106             (real_max_value_106     ),
    .real_max_value_107             (real_max_value_107     ),
    .real_max_value_108             (real_max_value_108     ),
    .real_max_value_109             (real_max_value_109     ),
    .real_max_value_110             (real_max_value_110     ),
    .real_max_value_111             (real_max_value_111     ),
    .real_max_value_112             (real_max_value_112     ),
    .real_max_value_113             (real_max_value_113     ),
    .real_max_value_114             (real_max_value_114     ),
    .real_max_value_115             (real_max_value_115     ),
    .real_max_value_116             (real_max_value_116     ),
    .real_max_value_117             (real_max_value_117     ),
    .real_max_value_118             (real_max_value_118     ),
    .real_max_value_119             (real_max_value_119     ),
    .real_max_value_120             (real_max_value_120     ),
    .real_max_value_121             (real_max_value_121     ),
    .real_max_value_122             (real_max_value_122     ),
    .real_max_value_123             (real_max_value_123     ),
    .real_max_value_124             (real_max_value_124     ),
    .real_max_value_125             (real_max_value_125     ),
    .real_max_value_126             (real_max_value_126     ),
    .real_max_value_127             (real_max_value_127     ),
    .real_max_value_128             (real_max_value_128     ),
    .real_max_value_129             (real_max_value_129     ),
    .real_max_value_130             (real_max_value_130     ),
    .real_max_value_131             (real_max_value_131     ),
    .real_max_value_132             (real_max_value_132     ),
    .real_max_value_133             (real_max_value_133     ),
    .real_max_value_134             (real_max_value_134     ),
    .real_max_value_135             (real_max_value_135     ),
    .real_max_value_136             (real_max_value_136     ),
    .real_max_value_137             (real_max_value_137     ),
    .real_max_value_138             (real_max_value_138     ),
    .real_max_value_139             (real_max_value_139     ),
    .real_max_value_140             (real_max_value_140     ),
    .real_max_value_141             (real_max_value_141     ),
    .real_max_value_142             (real_max_value_142     ),
    .real_max_value_143             (real_max_value_143     ),
    .real_max_value_144             (real_max_value_144     )
);

parameter               I2C_CLK_FREQ            = 100000;
wire                    i2c_read_trigger1;
wire                    i2c_write_trigger;
wire                    i2c_write_sync;
wire [ 7:0]             i2c_byte_in;

uart_business uart_business_u0 (
    .clk                            (clk                    ),
    .rst_n                          (rst_n                  ),
    .rx                             (uart_rxd               ),
    .tx                             (uart_txd               ),
    .i2c_read_trigger               (i2c_read_trigger1      ),
    .i2c_byte_out_en                (i2c_byte_out_en        ),
    .i2c_byte_out                   (i2c_byte_out           ),
    .i2c_write_trigger              (i2c_write_trigger      ),
    .i2c_write_sync                 (i2c_write_sync         ),
    .i2c_write_byte_sync            (i2c_byte_in            ),
    .uart_ri                        (uart_ri                ),
    .uart_trig_data                 (uart_trig_data         )
);

wire                    sda_eeprom_z;
wire                    sda_eeprom_out;
assign sda_eeprom = sda_eeprom_z ? 1'bz : sda_eeprom_out;
wire                    sda_eeprom_in = sda_eeprom;

iic_eeprom #(
    .MAIN_CLK_FREQ                  (MAIN_CLK_FREQ          ),
    .I2C_CLK_FREQ                   (I2C_CLK_FREQ           )
    ) iic_eeprom_inst (
    .clk                            (clk                    ),
    .rst_n                          (rst_n                  ),
    .i2c_read_trigger1              (i2c_read_trigger1      ),
    .i2c_write_trigger              (i2c_write_trigger      ),
    .i2c_write_sync                 (i2c_write_sync         ),
    .i2c_byte_in                    (i2c_byte_in            ),
    .scl                            (scl_eeprom             ),
    .sda_in                         (sda_eeprom_in          ),
    .sda_out                        (sda_eeprom_out         ),
    .sda_z                          (sda_eeprom_z           ),
    .i2c_byte_out_en                (i2c_byte_out_en        ),
    .i2c_byte_out                   (i2c_byte_out           )
);

wire                    batarry_sda_z;
wire                    batarry_sda_out;
assign batarry_sda = batarry_sda_z ? 1'bz : batarry_sda_out;
wire                    batarry_sda_in = batarry_sda;

batarry_ctrl #(
    .MAIN_CLK_FREQ                  (MAIN_CLK_FREQ          ),
    .I2C_CLK_FREQ                   (I2C_CLK_FREQ           )
    ) batarry_ctrl_inst (
    .clk                            (clk                    ),
    .rst_n                          (rst_n                  ),
    .supply_key                     (supply_key             ),
    .i2c_read_trigger               (i2c_read_trigger       ),
    .i2c_write_trigger              (1'b0                   ),
    .supply_out                     (supply_out             ),
    .scl                            (batarry_scl            ),
    .sda_in                         (batarry_sda_in         ),
    .sda_out                        (batarry_sda_out        ),
    .sda_z                          (batarry_sda_z          ),
    .batarry_protocol_volt          (batarry_protocol_volt  ),
    .batarry_sta1                   (batarry_sta1           ),
    .batarry_sta2                   (batarry_sta2           ),
    .batarry_led_red                (batarry_led_red        ),
    .batarry_led_green              (batarry_led_green      ),
    .batarry_led_blue               (batarry_led_blue       ),
    .batarry_protocol_stat          (batarry_protocol_stat  )
);



endmodule
