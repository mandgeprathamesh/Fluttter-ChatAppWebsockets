const express=require("express");
const app=express();
const port=8000;


const server=app.listen(port,()=>{
    console.log(`server runninng on port ${port}`);
});

const io=require("socket.io")(server);
const connecteduser=new Set();
io.on('connection',(socket)=>{
    console.log(`connected successfullly with:${socket.id}`);
    connecteduser.add(socket.id);
    io.emit('connnected-user',connecteduser.size);
    socket.on('disconnect',()=>{
        console.log(`Disconnected with:${socket.id}`);
        connecteduser.delete(socket.id);
        io.emit('connnected-user',connecteduser.size);
    });
    socket.on('message',(data)=>{
        console.log(data);
        socket.broadcast.emit('message-recieve',data);
    });
});

