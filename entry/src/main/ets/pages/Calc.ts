export function add(a:number, b:number):number {
  let c = a + b;
  console.info('Dynamic import, %d + %d = %d', a, b, c);
  return c;
}