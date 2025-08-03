const Task = require("../models/task");
const express = require("express");
const router = express.Router();

// Add task
router.post("/", async (req, res) => {
    try {
        const { task } = req.body;
        
        if (!task || task.trim().length === 0) {
            return res.status(400).json({ 
                error: "Task content is required" 
            });
        }

        const newTask = await new Task({ task: task.trim() }).save();
        res.status(201).json(newTask);
    } catch (error) {
        console.error('Error creating task:', error);
        res.status(500).json({ 
            error: "Failed to create task" 
        });
    }
});

// Get all tasks
router.get("/", async (req, res) => {
    try {
        const tasks = await Task.find().sort({ createdAt: -1 });
        res.status(200).json(tasks);
    } catch (error) {
        console.error('Error fetching tasks:', error);
        res.status(500).json({ 
            error: "Failed to fetch tasks" 
        });
    }
});

// Update task
router.put("/:id", async (req, res) => {
    try {
        const { id } = req.params;
        const updateData = req.body;

        const task = await Task.findByIdAndUpdate(
            id,
            updateData,
            { new: true, runValidators: true }
        );

        if (!task) {
            return res.status(404).json({ 
                error: "Task not found" 
            });
        }

        res.status(200).json(task);
    } catch (error) {
        console.error('Error updating task:', error);
        res.status(500).json({ 
            error: "Failed to update task" 
        });
    }
});

// Delete task
router.delete("/:id", async (req, res) => {
    try {
        const { id } = req.params;
        const task = await Task.findByIdAndDelete(id);

        if (!task) {
            return res.status(404).json({ 
                error: "Task not found" 
            });
        }

        res.status(200).json({ 
            message: "Task deleted successfully",
            deletedTask: task 
        });
    } catch (error) {
        console.error('Error deleting task:', error);
        res.status(500).json({ 
            error: "Failed to delete task" 
        });
    }
});

module.exports = router;
