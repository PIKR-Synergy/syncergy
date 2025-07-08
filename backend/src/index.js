// Entry point for Syncergy Backend (Express.js)
import express from 'express';
import cors from 'cors';
import router from './routes/index.js';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Syncergy Backend API is running.');
});

app.use('/api', router);

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});
