// Array to store all tasks
let tasks = [];
let currentFilter = 'all';

// Get DOM elements
const taskInput = document.getElementById('taskInput');
const addBtn = document.getElementById('addBtn');
const taskList = document.getElementById('taskList');
const showAllBtn = document.getElementById('showAll');
const showActiveBtn = document.getElementById('showActive');
const showCompletedBtn = document.getElementById('showCompleted');

// Task constructor
function Task(text) {
    this.id = Date.now();
    this.text = text;
    this.completed = false;
}

// Add event listeners
addBtn.addEventListener('click', addTask);
taskInput.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        addTask();
    }
});

showAllBtn.addEventListener('click', () => setFilter('all'));
showActiveBtn.addEventListener('click', () => setFilter('active'));
showCompletedBtn.addEventListener('click', () => setFilter('completed'));

// Add a new task
function addTask() {
    const taskText = taskInput.value.trim();
    
    if (taskText === '') {
        alert('Please enter a task!');
        return;
    }
    
    const newTask = new Task(taskText);
    tasks.push(newTask);
    
    taskInput.value = '';
    renderTasks();
}

// Toggle task completion status
function toggleTask(taskId) {
    const task = tasks.find(t => t.id === taskId);
    if (task) {
        task.completed = !task.completed;
        renderTasks();
    }
}

// Set filter and update active button
function setFilter(filter) {
    currentFilter = filter;
    
    // Update active button
    document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    
    if (filter === 'all') {
        showAllBtn.classList.add('active');
    } else if (filter === 'active') {
        showActiveBtn.classList.add('active');
    } else if (filter === 'completed') {
        showCompletedBtn.classList.add('active');
    }
    
    renderTasks();
}

// Filter tasks based on current filter
function getFilteredTasks() {
    if (currentFilter === 'active') {
        return tasks.filter(task => !task.completed);
    } else if (currentFilter === 'completed') {
        return tasks.filter(task => task.completed);
    }
    return tasks; // 'all'
}

// Render tasks to the DOM
function renderTasks() {
    const filteredTasks = getFilteredTasks();
    taskList.innerHTML = '';
    
    if (filteredTasks.length === 0) {
        const emptyMessage = document.createElement('li');
        emptyMessage.textContent = 'No tasks to show';
        emptyMessage.style.textAlign = 'center';
        emptyMessage.style.color = '#888';
        emptyMessage.style.fontStyle = 'italic';
        emptyMessage.style.padding = '20px';
        taskList.appendChild(emptyMessage);
        return;
    }
    
    filteredTasks.forEach(task => {
        const taskItem = document.createElement('li');
        taskItem.className = `task-item ${task.completed ? 'completed' : ''}`;
        
        taskItem.innerHTML = `
            <input type="checkbox" class="task-checkbox" ${task.completed ? 'checked' : ''}>
            <span class="task-text">${task.text}</span>
        `;
        
        // Add click event to checkbox
        const checkbox = taskItem.querySelector('.task-checkbox');
        checkbox.addEventListener('change', () => toggleTask(task.id));
        
        taskList.appendChild(taskItem);
    });
}
