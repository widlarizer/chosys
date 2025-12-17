// yosys -m rtlil-emit/build/librtlil-emit.so -p "read_mlir rtlil-emit/example/not.mlir; dump"
// Top level module. All MLIR textual files need a generic top-level module.
module {
  // An actual RTLIL module named "\not"
  module @"\\not" {
    // Value %0 refers to this converted wire
    %0 = "rtlil.wire"() <{
      // Special case: attributes other than src are implemented in the extraAttrs MLIR attribute
      extraAttrs = {"\\foo" = "bar"},
      // MLIR attributes are otherwise an exact model of the fields of an RTLIL Wire
      is_signed = false,
      name = "\\i1",
      port_id = 1 : i32,
      port_input = true,
      port_output = false,
      start_offset = 0 : i32,
      upto = false,
      width = 1 : i32}>
      // This MLIR op takes no inputs and its result value is a 1-bit RTLIL value
      : () -> !rtlil<val[1 : i32]>
      // This wire was generated when processing file foo.bar line 1 column 2
      // If imported into Yosys RTLIL, it will be converted to a src attribute
      loc ("foo.bar":1:2)
    %1 = "rtlil.wire"() <{is_signed = false, name = "\\o1", port_id = 2 : i32, port_input = false, port_output = true, start_offset = 0 : i32, upto = false, width = 1 : i32}> : () -> !rtlil<val[1 : i32]>

    // Example of a generic CellOp, not a concrete NotOp
    "rtlil.cell"(%0, %1) <{
      // All objects are named in Yosys, dollar-prefixed names are "private" (automatically generated, discardable) and backslash-prefixed names come from user code and are retained
      name = "$2",
      // The total function of the cell is defined by its type and parameters
      parameters = [#rtlil<param "\\A_SIGNED" 0 : i32>, #rtlil<param "\\A_WIDTH" 1 : i32>, #rtlil<param "\\Y_WIDTH" 1 : i32>],
      // This is the "signature" of the function. A generic CellOp needs to "know" its own signature in an attribute, unlike concrete ops, where the ports value is derived on-demand by MLIR from its MLIR type (not type attribute)
      ports = ["\\A", "\\Y"],
      type = "$not",
      extraAttrs = {"\\x" = "y"}}>
      // This defines the widths of its ports as defined in the ports attributes
      : (!rtlil<val[1 : i32]>, !rtlil<val[1 : i32]>) -> ()
  }
}

autoidx 1

module \not

  attribute \src "rtlil-emit/example/not.mlir:24:10"
  wire output 2 \o1

  attribute \foo "bar"
  attribute \src "foo.bar:1:2"
  wire input 1 \i1

  attribute \x "y"
  attribute \src "rtlil-emit/example/not.mlir:25:5"
  cell $not $2
    parameter \Y_WIDTH 1
    parameter \A_WIDTH 1
    parameter \A_SIGNED 0
    connect \Y \o1
    connect \A \i1
  end
end