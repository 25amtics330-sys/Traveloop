const express = require('express');
const app = express();
const PORT = 5001;
app.listen(PORT, () => {
    console.log(`Debug server listening on port ${PORT}`);
});
setInterval(() => { console.log('Heartbeat'); }, 1000);
