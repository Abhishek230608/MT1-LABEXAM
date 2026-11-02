import { spawn } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function run() {
  console.log("Starting httpServer.js on port 3000...");
  const httpProcess = spawn('node', ['httpServer.js'], { cwd: __dirname, stdio: 'inherit' });

  console.log("Starting expressApp.js on port 4000...");
  const expressProcess = spawn('node', ['expressApp.js'], { cwd: __dirname, stdio: 'inherit' });

  // Give servers time to bind to their ports
  await sleep(1500);

  console.log("\nRunning test.js...\n");
  const testProcess = spawn('node', ['test.js'], { cwd: __dirname, stdio: 'inherit' });

  testProcess.on('exit', (code) => {
    console.log(`\nTests finished with exit code ${code}. Stopping servers...`);
    httpProcess.kill();
    expressProcess.kill();
    process.exit(code);
  });
}

run();
