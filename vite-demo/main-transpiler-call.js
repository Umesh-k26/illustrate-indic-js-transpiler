import { transpiler} from './src/transpiler/';

export function transpileCode(clickElement, outputElement, codeElement, convertedCodeElement) {
  const getTranspiledOutput = () => {
    if (codeElement.value !== "") {
      const output = transpiler(codeElement.value);
      // const interpretedoutput = interpreter(output);
      convertedCodeElement.value = output
      // outputElement.innerHTML = output
    } else {
      // outputElement.innerHTML = "output language"
    }
    clickElement.innerHTML = "transpile"
  }
  clickElement.addEventListener('click', () => getTranspiledOutput())
  getTranspiledOutput()
}