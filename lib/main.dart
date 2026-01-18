import 'package:flutter/material.dart';

void main() {
  runApp(const SmartdayApp());
}

class SmartdayApp extends StatelessWidget {
  const SmartdayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartday',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// --- ГЛАВНЫЙ ЭКРАН С НАВИГАЦИЕЙ ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Чтобы передать список задач на страницу HomePage, мы создадим его здесь
  // или (для простоты сейчас) оставим управление внутри HomePage.
  // В данном примере переключение табов просто меняет экраны.
  
  static final List<Widget> _pages = <Widget>[
    const HomePage(),       // Экран задач (теперь он умный!)
    const Placeholder(),    // Привычки
    const Placeholder(),    // Календарь
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Сегодня',
          ),
          NavigationDestination(
            icon: Icon(Icons.loop),
            selectedIcon: Icon(Icons.loop),
            label: 'Привычки',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Календарь',
          ),
        ],
      ),
    );
  }
}

// --- МОДЕЛЬ ЗАДАЧИ ---
// Простой класс, описывающий одну задачу
class Task {
  String name;
  String time;
  bool isDone;
  bool isPriority;

  Task({
    required this.name, 
    required this.time, 
    this.isDone = false, 
    this.isPriority = false
  });
}

// --- СТРАНИЦА ЗАДАЧ (ТЕПЕРЬ С ЖИВЫМИ КНОПКАМИ) ---

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Наш список задач (данные)
  final List<Task> _tasks = [
    Task(name: "Утренняя пробежка", time: "07:00", isDone: true),
    Task(name: "Планерка с командой", time: "10:00", isDone: false),
    Task(name: "Изучение Flutter", time: "14:00", isPriority: true),
    Task(name: "Чтение книги", time: "21:00"),
  ];

  // Контроллер для ввода текста в диалоговом окне
  final TextEditingController _taskController = TextEditingController();

  // Функция переключения галочки
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isDone = !_tasks[index].isDone;
    });
  }

  // Функция добавления задачи
  void _addNewTask(String taskName) {
    if (taskName.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          name: taskName, 
          time: "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}" // Текущее время
        ));
      });
      _taskController.clear(); // Очистить поле ввода
      Navigator.of(context).pop(); // Закрыть диалог
    }
  }

  // Показать диалог добавления
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Новая задача"),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: "Например: Купить молоко"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Отмена
            child: const Text("Отмена"),
          ),
          FilledButton(
            onPressed: () => _addNewTask(_taskController.text), // Добавить
            child: const Text("Добавить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Считаем выполненные задачи для прогресса
    int completedCount = _tasks.where((t) => t.isDone).length;
    double progress = _tasks.isEmpty ? 0 : completedCount / _tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Привет! 👋", style: Theme.of(context).textTheme.titleMedium),
            Text("Готов к продуктивному дню?", style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
      // Кнопка добавления переехала сюда, чтобы быть поверх списка
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка прогресса (теперь живая!)
            _buildProgressCard(completedCount, _tasks.length, progress),
            
            const SizedBox(height: 24),
            Text(
              "Задачи на сегодня",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Список задач
            Expanded(
              child: _tasks.isEmpty 
                ? const Center(child: Text("Задач нет. Отдыхайте!"))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskTile(index);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(int done, int total, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ваш прогресс", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          Text(
            "$done из $total задач выполнено",
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

 Widget _buildTaskTile(int index) {
    final task = _tasks[index];
    
    return Card(
      elevation: 0,
      color: task.isDone 
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) 
          : Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        // ИЗМЕНЕНИЕ: Теперь onTap делает навигацию (Navigator.push)
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(task: task), // Передаем задачу
            ),
          );
        },
        leading: Checkbox(
          value: task.isDone,
          onChanged: (val) => _toggleTask(index), 
          shape: const CircleBorder(),
        ),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            fontWeight: task.isPriority ? FontWeight.bold : FontWeight.normal,
            color: task.isDone ? Colors.grey : null, 
          ),
        ),
        subtitle: Text(task.time),
        // Добавим стрелочку справа, чтобы намекнуть, что можно нажать
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
