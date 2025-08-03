import React, { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Plus, Trash2, Check, Circle } from "lucide-react";
import "./App.css";
import {
    addTask,
    getTasks,
    updateTask,
    deleteTask,
} from "./services/taskServices";

function App() {
    const [tasks, setTasks] = useState([]);
    const [currentTask, setCurrentTask] = useState("");
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        fetchTasks();
    }, []);

    const fetchTasks = async () => {
        try {
            const { data } = await getTasks();
            setTasks(data);
            setIsLoading(false);
        } catch (error) {
            console.log(error);
            setIsLoading(false);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!currentTask.trim()) return;

        const originalTasks = [...tasks];
        try {
            const { data } = await addTask({ task: currentTask });
            setTasks([...tasks, data]);
            setCurrentTask("");
        } catch (error) {
            console.log(error);
            setTasks(originalTasks);
        }
    };

    const handleUpdate = async (taskId) => {
        const originalTasks = [...tasks];
        try {
            const updatedTasks = tasks.map((task) => {
                if (task._id === taskId) {
                    return { ...task, completed: !task.completed };
                }
                return task;
            });
            setTasks(updatedTasks);
            
            const taskToUpdate = tasks.find(task => task._id === taskId);
            await updateTask(taskId, {
                completed: !taskToUpdate.completed,
            });
        } catch (error) {
            console.log(error);
            setTasks(originalTasks);
        }
    };

    const handleDelete = async (taskId) => {
        const originalTasks = [...tasks];
        try {
            const filteredTasks = tasks.filter((task) => task._id !== taskId);
            setTasks(filteredTasks);
            await deleteTask(taskId);
        } catch (error) {
            console.log(error);
            setTasks(originalTasks);
        }
    };

    if (isLoading) {
        return (
            <div className="app">
                <div className="loading-container">
                    <motion.div
                        className="loading-spinner"
                        animate={{ rotate: 360 }}
                        transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    />
                    <p>Loading tasks...</p>
                </div>
            </div>
        );
    }

    return (
        <div className="app">
            <motion.header 
                className="app-header"
                initial={{ y: -50, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ duration: 0.6 }}
            >
                <h1>Tasks</h1>
                <p>Organize your day with simplicity</p>
            </motion.header>
            
            <div className="main-content">
                <motion.div 
                    className="todo-container"
                    initial={{ scale: 0.9, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    transition={{ duration: 0.5, delay: 0.2 }}
                >
                    <form onSubmit={handleSubmit} className="task-form">
                        <div className="input-container">
                            <input
                                type="text"
                                className="task-input"
                                value={currentTask}
                                onChange={(e) => setCurrentTask(e.target.value)}
                                placeholder="Add a new task..."
                            />
                            <motion.button
                                type="submit"
                                className="add-task-btn"
                                whileHover={{ scale: 1.05 }}
                                whileTap={{ scale: 0.95 }}
                                disabled={!currentTask.trim()}
                            >
                                <Plus size={20} />
                            </motion.button>
                        </div>
                    </form>

                    <div className="tasks-list">
                        <AnimatePresence>
                            {tasks.map((task) => (
                                <motion.div
                                    key={task._id}
                                    className="task-item"
                                    initial={{ opacity: 0, y: 20 }}
                                    animate={{ opacity: 1, y: 0 }}
                                    exit={{ opacity: 0, x: -100 }}
                                    transition={{ duration: 0.3 }}
                                    layout
                                >
                                    <motion.button
                                        className="task-checkbox"
                                        onClick={() => handleUpdate(task._id)}
                                        whileHover={{ scale: 1.1 }}
                                        whileTap={{ scale: 0.9 }}
                                    >
                                        {task.completed ? (
                                            <Check size={16} className="check-icon" />
                                        ) : (
                                            <Circle size={16} className="circle-icon" />
                                        )}
                                    </motion.button>
                                    
                                    <span className={`task-text ${task.completed ? 'completed' : ''}`}>
                                        {task.task}
                                    </span>
                                    
                                    <motion.button
                                        onClick={() => handleDelete(task._id)}
                                        className="delete-task-btn"
                                        whileHover={{ scale: 1.1 }}
                                        whileTap={{ scale: 0.9 }}
                                    >
                                        <Trash2 size={16} />
                                    </motion.button>
                                </motion.div>
                            ))}
                        </AnimatePresence>
                        
                        {tasks.length === 0 && (
                            <motion.div 
                                className="empty-state"
                                initial={{ opacity: 0 }}
                                animate={{ opacity: 1 }}
                                transition={{ delay: 0.5 }}
                            >
                                <p>No tasks yet. Add one above to get started!</p>
                            </motion.div>
                        )}
                    </div>
                </motion.div>
            </div>
        </div>
    );
}

export default App;

