export default {
  plugins: [
    {
      name: 'replace-process-env',
      transform(code) {
        return {
          code: code.replace(/globalThis\.process\.env\.NODE_ENV/g, '"production"'), // or '"development"' based on your environment
          map: null // no need for source maps
        };
      }
    }
  ]
}