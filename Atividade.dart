//server
const express = require('express');
const PORT =
3000;
const cors = require('cors');
const bodyParser = require('body-parser');
app.listen(PORT, () => {
console.log("Servidor rodando em http://localhost:${PORT}");
const app = express();
});
module.exports = app;
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
const clientRoutes
=
require('./routes/clients');
const orderRoutes = require('./routes/orders');
app.use('/api/clients', clientRoutes);
app.use('/api/orders', orderRoutes);
app.get('/', (req, res) => {
res.json({
message: 'API rodando!',
timestamp: new Date().toISOString()
});
});

const mariadb = require('mariadb');
const pool = mariadb.createPool({
    host:'localhost',
    usar:'root',
    password:'fitodb',/*senha do seu banco*/
    database:'cliente_order_system',
    port:3306,
    connectionLimit:10


});
module.exports = pool;



//cliente 
const express = require('express');
const router =
express.Router();
const pool = require('../db');
// GET all clients
router.get('/', async (req, res) => {
try {
const clients = await pool.query('SELECT * FROM clients ORDER BY created_at DESC');
res.json(clients);
} catch (error) {
res.status(500).json({ error: error.message });
}});
 
router.get('/:id', async (req, res) => {
try {
const client = await pool.query('SELECT * FROM clients WHERE client_id = ?', [req.params.id]);
if (client.length === 0) {
    return res.status(404).json({ error: 'Cliente não encontrado' });
}
res.json(client[0]);
} catch (error) {
    res.status(500).json({ error: error.message });
}});
 
//get single client
 
router.post('/', async (req, res) => {
const { name, email, address } = req.body;
if (!name || !email) {
    return res.status(400).json({ error: 'Nome e email são obrigatórios' });
} try {
    const result = await pool.query(
    'INSERT INTO clients (name, email, address) VALUES (?, ?, ?)',
    [name, email, address]
    );
    res.status(201).json({
        client_id: result.affectedRows.client_id,
        message: 'Cliente criado com sucesso'
        });
        }catch (error) {
if (error.code === 'ER_DUP_ENTRY') {
res.status(409).json({ error: 'Email já cadastrado' });
} else {
    res.status(500).json({ error: error.message });
        }
    }
});
//PUT update client
router.put('/:id', async (req, res) => {
const { name, email, address } = req.body;
try {


const result = await pool.query(
'UPDATE clients SET name = ?, email = ?, address = ? WHERE client_id = ?',
[name, email, address, req.params.id]
);
if (result.affectedRows === 0){
    return res.status(404).json({ error: 'Cliente não encontrado' });
}
res.json({ message: 'Cliente atualizado com sucesso' });
} catch (error) {
    res.status(500).json({ error: error.message });
}
});
 
// DELETE client
router.delete('/:id', async (req, res) => {
    try {
     
    const result =  
    await pool.query('DELETE FROM clients WHERE client_id =?', [req.params.id]);
 
    if (result.affectedRows === 0) {
        return res.status(404).json({ error: 'Cliente não encontrado' });
    }
    res.json({ message: 'Cliente excluído successo' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }});
     


    module.exports = router;
   
const express = require(“express”);
const router = express.Router();
const pool = require (“../db”);


//GET all orders with client information


router.get(‘/’, async (req, res) => {
  try {
    const orders = await pool.query(
      SELECT o.*, c.name as client_name, c.email as client_email
      FROM orders o
      JOIN clients c ON o.client_id = c.client_id
      ORDER BY o.created_at DESC
  );
  res.json(orders);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
// GET ORDERS BY CLIENT


router.get(‘/client/:clientId’, async (req, res) => {
  try {
    const orders = await pool.query(
      ‘SELECT * FROM orders WHERE client_id = ? ORDER BY created_at DESC’,
      [req.params.clientId]
    );
    res.json(orders);
  } catch (error) {
  res.status(500).json({ error: error.message });
  }
});




//POST CREATE ORDER


router.post(‘/’), async (req, res) => {
  const { client_id, order_date, total_amount, status } = red.body;


  if (!client_id | | !order_date | | !total_amount) {
    return res.status(400).json({ error: ‘Client ID, order date, and total amount are required’ });
  }


  try {
    const result = await pool.query(
      ‘INSERT INTO orders (client_id, order_date, toral_amount, status)
      VALUES (?, ?, ?, ?)’,
      [client_id, order_date, total_amount, status | | ‘peding’]
    );
    res.status(201)json({
      order_id: result.affectedRows.insertId,
      message: ‘Pedido criado com sucesso’
    });
}
// PUT update order
router.put('/:id', async (req, res) => {
  const { order_date, total_amount, status } = req.body;
  try {
    const result = await pool.query(
      "UPDATE orders SET order_date = ?, total_amount = ?, status = ? WHERE order_id = ?",
      [order_date, total_amount, status, req.params.id]
    );
    if (result.affectedRows === 0) {
      return res.status(484).json((error: 'Pedido não encontrado'));
    }
    res.json({message: 'Pedido atualizado com sucesso' });
  } catch (error) {
    res.status(588).json((error: error.message));
  }
});
// DELETE order
router.delete('/:id', async (req, res) => {
  try {
    const result await pool.query('DELETE FROM orders WHERE order_id=?', [req.params.id]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Pedido não encontrado' });
    }
    res.json({ message: 'Pedido deletado com sucesso' });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
});
module.exports = router;
