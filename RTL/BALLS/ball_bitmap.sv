

module ball_bitmap (
    input logic clk,
    input logic resetN,
    input logic [10:0] offsetX, // offset from top left  position 
    input logic [10:0] offsetY,
    input logic InsideRectangle, //input that the pixel is within a bracket 
    output logic drawingRequest, //output that the pixel should be dispalyed 
    output logic [7:0] RGBout //rgb value form the bitmap 
);

parameter  logic [7:0] BALL_COLOR = 8'h5b ; 

//localparam  int OBJECT_WIDTH_X = 32;
//localparam  int OBJECT_HEIGHT_Y = 32;
//localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFE ;// RGB value in the bitmap representing a transparent pixel 
//
//
//logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'hDA, 8'hB6, 8'hB6, 8'hBA, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h92, 8'h69, 8'h85, 8'h80, 8'h80, 8'h80, 8'h80, 8'h85, 8'h69, 8'h92, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'h65, 8'hA0, 8'hC0, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'hC0, 8'hA0, 8'h65, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h69, 8'h80, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h80, 8'h69, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h69, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h69, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h69, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h69, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h65, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h65, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h69, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h69, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'h85, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h85, 8'hDB, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hBA, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'hDA, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hB6, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'hB6, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hB6, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'hB6, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hDA, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'hBA, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'h85, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h85, 8'hDB, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h69, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h69, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h65, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h65, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'h80, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h80, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h69, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h69, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h69, 8'hA0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA0, 8'h69, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h69, 8'h80, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'h80, 8'h69, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'h92, 8'h65, 8'hA0, 8'hC0, 8'hC0, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hC0, 8'hC0, 8'hA0, 8'h65, 8'h92, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDF, 8'h92, 8'h69, 8'h85, 8'h80, 8'h80, 8'h80, 8'h80, 8'h85, 8'h69, 8'h92, 8'hDF, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, 8'hBA, 8'hB6, 8'hB6, 8'hDA, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE },
//{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE }
//};


//logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hD6, 8'hD2, 8'hAD, 8'hAD, 8'hD2, 8'hD6, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hAD, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA4, 8'hAD, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDA, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hDA, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hA5, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA5, 8'hFF, 8'hFF, },
//{8'hFF, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFF, },
//{8'hFF, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFF, },
//{8'hDB, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDB, },
//{8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, },
//{8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, },
//{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, },
//{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, },
//{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, },
//{8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, },
//{8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, },
//{8'hFB, 8'h84, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h84, 8'hFB, },
//{8'hFF, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFF, },
//{8'hFF, 8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, 8'hFF, },
//{8'hFF, 8'hFF, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hDA, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDA, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD6, 8'hA5, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA5, 8'hD6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hD2, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA4, 8'hD2, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFB, 8'hD6, 8'hAD, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA4, 8'hAD, 8'hD6, 8'hFB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, },
//{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hDB, 8'hDA, 8'hD6, 8'hD6, 8'hDA, 8'hDB, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, }
//};

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFE ;// RGB value in the bitmap representing a transparent pixel 
localparam  int OBJECT_WIDTH_X = 32;
localparam  int OBJECT_HEIGHT_Y = 32;

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hA5, 8'hA5, 8'hFE, 8'hA5, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hA5, 8'hDA, 8'hD6, 8'hD2, 8'hAD, 8'hAD, 8'hD2, 8'hD6, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD6, 8'hAD, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA4, 8'hAD, 8'hD6, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDA, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hDA, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hDB, 8'hDB, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, 8'hDB, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hA5, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA5, 8'hDB, 8'hFE, },
{8'hFE, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFE, },
{8'hDB, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hDB, },
{8'hDB, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDB, },
{8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDB, 8'hD6, },
{8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h84, 8'hD2, },
{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h84, 8'hAD, },
{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h84, 8'hAD, },
{8'hAD, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hAD, },
{8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, },
{8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, },
{8'hFB, 8'h84, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'h84, 8'hFB, },
{8'hFE, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFE, },
{8'hFE, 8'hD6, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD6, 8'hFE, },
{8'hFE, 8'hFE, 8'hA9, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA9, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hDA, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDA, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hDB, 8'hDB, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hDB, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD2, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hD2, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD6, 8'hA5, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA5, 8'hD6, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hD2, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hA4, 8'hD2, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFB, 8'hD6, 8'hAD, 8'hA4, BALL_COLOR, BALL_COLOR, BALL_COLOR, 8'hDB, 8'hDB, 8'hDB, 8'hA4, 8'hAD, 8'hD6, 8'hFB, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, },
{8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hDB, BALL_COLOR, 8'hD6, 8'hD6, 8'hDA, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hDB, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, }
};



always_ff@(posedge clk)
begin
       if (InsideRectangle == 1'b1 ) begin // inside an external bracket 
            if (object_colors[offsetY<<1][offsetX<<1] != TRANSPARENT_ENCODING) begin
               drawingRequest <= 1'b1;
					if (object_colors[offsetY<<1][offsetX<<1] != BALL_COLOR) begin
						RGBout      <= 8'h00;
					end else begin
						RGBout      <= object_colors[offsetY<<1][offsetX<<1];
					end
            end else begin
					RGBout      <= object_colors[offsetY<<1][offsetX<<1];
					drawingRequest <= 1'b0;
				end
       end else begin
            drawingRequest <= 1'b0;
				RGBout      <= object_colors[offsetY<<1][offsetX<<1];
		 end
end

endmodule