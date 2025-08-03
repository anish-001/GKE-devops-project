const mongoose = require("mongoose");

module.exports = async () => {
    try {
        const connectionParams = {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        };

        // Get MongoDB connection string from environment or use default
        const mongoConnStr = process.env.MONGO_CONN_STR || "mongodb://localhost:27017/todo";
        const useDBAuth = process.env.USE_DB_AUTH === 'true';
        
        if (useDBAuth) {
            connectionParams.user = process.env.MONGO_USERNAME;
            connectionParams.pass = process.env.MONGO_PASSWORD;
        }

        // For production with authentication, modify the connection string
        let finalConnStr = mongoConnStr;
        if (useDBAuth && mongoConnStr.includes('mongodb://')) {
            // Convert mongodb:// to mongodb://username:password@host:port/database
            const username = process.env.MONGO_USERNAME;
            const password = process.env.MONGO_PASSWORD;
            const url = new URL(mongoConnStr);
            url.username = username;
            url.password = password;
            finalConnStr = url.toString();
        }

        console.log(`Attempting to connect to MongoDB: ${finalConnStr.replace(/\/\/.*@/, '//***:***@')}`);
        
        await mongoose.connect(finalConnStr, connectionParams);
        console.log("✅ Connected to database successfully.");
    } catch (error) {
        console.error("❌ Could not connect to database:", error.message);
        console.log("💡 Make sure MongoDB is running and accessible.");
        console.log("💡 For local development, you can start MongoDB with: docker run -d -p 27017:27017 --name mongodb mongo:4.4.6");
    }
};
