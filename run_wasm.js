#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Read the WASM file
const wasmPath = process.argv[2] || 'target/wasm-gc/release/build/main/main.wasm';
const wasmBuffer = fs.readFileSync(wasmPath);


const imports = {
  spectest: {
    print_char: (char) => {
      // Convert the character code to a character and print it
      process.stdout.write(String.fromCharCode(char));
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