#!/usr/bin/env node

const fs = require('fs');

// Read the WASM file
const wasmPath = process.argv[2] || 'target/wasm-gc/release/build/main/main.wasm';
const wasmBuffer = fs.readFileSync(wasmPath);

// Get command line arguments (skip node, script name, and wasm path)
const args = process.argv.slice(3);
const argsStrings = args.map(arg => arg.toString());

// Create handles for tracking string operations
let stringHandleCounter = 0;
let stringArrayHandleCounter = 0;
const stringHandles = new Map();
const stringArrayHandles = new Map();

// Create a comprehensive WASM runtime
const imports = {
  spectest: {
    print_char: (char) => {
      process.stdout.write(String.fromCharCode(char));
    }
  },
  env: {
    args: () => argsStrings
  },
  // my custom ffi module
  custom_module: {
    push_js_array: (array, value) => {
      array.push(value);
      return array;
    },
    make_js_array: () => {
      return [];
    },
    read_cipher_from_file: (lineNumber) => {
      const lines = fs.readFileSync("key_store.txt", "utf8").split("\n");
      return lines[lineNumber] || "";
    },
    get_byte_from_js_string: (jsString, index) => {
      const bytes = jsString.split(":");
      return parseInt(bytes[index] || "0");
    },
    append_to_key_store: (array) => {
      try {
        fs.appendFileSync("key_store.txt", array.join(":") + "\n");
        return fs.readFileSync("key_store.txt", "utf8").split("\n").length;
      } catch (error) {
        console.error("Error appending to key store:", error);
        return 0;
      }
    },
    // for parse program
    read_string_from_file: () => {
      return fs.readFileSync("string_store.txt", "utf8");
    },
    write_to_string_store: (s) => {
      fs.writeFileSync("string_store.txt", s);
    },
    js_string_length: (s) => {
      return s.length;
    },
    js_string_char_at: (s, i) => {
      return s.charCodeAt(i);
    },
    make_js_byte_array: () => {
      return [];
    },
    push_to_js_byte_array: (byteArray, byte) => {
      byteArray.push(byte);
      return byteArray;
    },
    write_byte_array_to_string_store: (byteArray) => {
      const str = String.fromCharCode(...byteArray);
      fs.writeFileSync("string_store.txt", str);
    }
  },
  __moonbit_fs_unstable: {
    // String operations
    begin_read_string: (externString) => {
      const handle = stringHandleCounter++;
      stringHandles.set(handle, externString);
      return handle;
    },
    string_read_char: (handle) => {
      const str = stringHandles.get(handle);
      if (!str || str.length === 0) return -1;
      const char = str.charCodeAt(0);
      stringHandles.set(handle, str.slice(1));
      return char;
    },
    finish_read_string: (handle) => {
      stringHandles.delete(handle);
    },
    
    // String array operations
    begin_read_string_array: (externStringArray) => {
      const handle = stringArrayHandleCounter++;
      stringArrayHandles.set(handle, [...argsStrings, "ffi_end_of_/string_array"]);
      return handle;
    },
    string_array_read_string: (handle) => {
      const array = stringArrayHandles.get(handle);
      if (!array || array.length === 0) return "ffi_end_of_/string_array";
      const str = array.shift();
      return str;
    },
    finish_read_string_array: (handle) => {
      stringArrayHandles.delete(handle);
    },
    
    // Command line arguments
    args_get: () => {
      const handle = stringArrayHandleCounter++;
      stringArrayHandles.set(handle, [...argsStrings, "ffi_end_of_/string_array"]);
      return handle;
    },
    
    // Current directory
    current_dir: () => process.cwd()
  },
  
  __moonbit_time_unstable: {
    now: () => Date.now()
  },
  
  __moonbit_rt: {
    panic: () => {
      console.error("Panic!");
      process.exit(1);
    },
    abort: () => {
      console.error("Abort!");
      process.exit(1);
    },
    trace: () => {},
    trace_num: () => {},
    trace_str: () => {},
    trace_any: () => {}
  },
  
  __moonbit_alloc: {
    malloc: (size) => {
      // Simple malloc implementation
      return Math.floor(Math.random() * 1000000);
    },
    realloc: (ptr, size) => {
      return ptr;
    }
  },
  
  __moonbit_dealloc: {
    free: (ptr) => {
      // Simple free implementation
    }
  },
  
  __moonbit_gc: {
    gc: () => {
      // Simple GC implementation
    }
  }
};

// Instantiate and run the WASM module
async function runWasm() {
  try {
    const wasmModule = await WebAssembly.instantiate(wasmBuffer, imports);
    
    // Call the _start function (or main)
    if (wasmModule.instance.exports._start) {
      wasmModule.instance.exports._start();
    } else if (wasmModule.instance.exports.main) {
      wasmModule.instance.exports.main();
    } else {
      console.log('No _start or main function found in WASM module');
      console.log('Available exports:', Object.keys(wasmModule.instance.exports));
    }
  } catch (error) {
    console.error('Error running WASM:', error);
  }
}

runWasm();
