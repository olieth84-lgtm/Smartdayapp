// --- ЭКРАН ДЕТАЛЕЙ (НОВЫЙ) ---

class DetailsScreen extends StatelessWidget {
  final Task task; // Принимаем задачу как параметр

  const DetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали задачи'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Иконка и Название
            Row(
              children: [
                Icon(
                  task.isPriority ? Icons.flag : Icons.task_alt,
                  color: task.isPriority ? Colors.red : Colors.indigo,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    task.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Время
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  "Время выполнения: ${task.time}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Статус
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: task.isDone ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                task.isDone ? "Статус: Выполнено ✅" : "Статус: В процессе ⏳",
                style: TextStyle(
                  color: task.isDone ? Colors.green : Colors.orange[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Кнопка "Назад" (как в задании Navigator.pop)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Возврат назад
                },
                child: const Text("Вернуться к списку"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
