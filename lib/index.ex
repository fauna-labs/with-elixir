defmodule Index do
  alias Dotenv

  def start(_type, _args) do
    IO.puts("Welcome to the Todo App!")

    loop("")
  end

  defp loop(_choice) do
    IO.puts("Choose an option:")
    IO.puts("1. Create Todo")
    IO.puts("2. View all Todos")
    IO.puts("3. View Todo by ID")
    IO.puts("4. View Todo by Content")
    IO.puts("5. View Todo by Status")
    IO.puts("6. Edit Todo")
    IO.puts("7. Delete Todo")
    IO.puts("8. Exit")

    input = IO.gets("Enter your choice: ") |> String.trim() |> String.to_integer()

    case input do
      1 -> create_todo()
      2 -> view_all_todos()
      3 -> view_todo_by_id()
      4 -> view_todo_by_content()
      5 -> view_todo_by_status()
      6 -> edit_todo()
      7 -> delete_todo()
      8 -> exit()
      _ -> IO.puts("Invalid choice. Please try again.")
    end

    loop(input)
  end

  defp create_todo do
    IO.puts("Enter Todo content:")
    content = IO.gets("") |> String.trim()

    query = """
      Todo.create({"todo": "#{content}", "completed": false})
    """

    execute_query(query)
  end

  defp view_all_todos do
    query = """
      Todo.all()
    """

    execute_query(query)
  end

  defp view_todo_by_id do
    IO.puts("Enter Todo ID:")
    id = IO.gets("") |> String.trim()

    query = """
      Todo.byId(#{id})
    """

    execute_query(query)
  end

  defp view_todo_by_content do
    IO.puts("Enter Todo content:")
    content = IO.gets("") |> String.trim()

    query = """
      Todo.where(.todo.includes("#{content}"))
    """

    execute_query(query)
  end

  defp view_todo_by_status do
    IO.puts("Enter Todo completed status (true/false):")
    status = IO.gets("") |> String.trim()
    completed = String.to_existing_atom(status)

    query = """
      Todo.where(.completed == #{completed})
    """

    execute_query(query)
  end

  defp edit_todo do
    IO.puts("Enter Todo ID:")
    id = IO.gets("") |> String.trim()

    IO.puts("Enter new content (press Enter to skip):")
    new_content = IO.gets("") |> String.trim()

    IO.puts("Enter completed status (true/false):")
    completed_str = IO.gets("") |> String.trim()
    completed = String.to_existing_atom(completed_str)

    query =
      if new_content != "" do
        """
        let toEdit = Todo.byId(#{id})
        toEdit.update({ todo: "#{new_content}", completed: #{completed} })
        """
      else
        """
        let toEdit = Todo.byId(#{id})
        toEdit.update({ completed: #{completed} })
        """
      end

    execute_query(query)
  end

  defp delete_todo do
    IO.puts("Enter Todo ID:")
    id = IO.gets("") |> String.trim()

    query = """
      let toDelete = Todo.byId(#{id})
      toDelete.delete()
    """

    execute_query(query)
  end

  defp execute_query(query) do
    key = System.get_env("FAUNA_KEY")

    case Faunadoo.query(query, key) do
      {:ok, data} ->
        IO.puts("Query result: #{Kernel.inspect(data)}")

      {:error, reason} ->
        IO.puts("Failed to execute query: #{reason}")
    end
  end

  defp exit do
    IO.puts("Goodbye!")
    System.halt(0)
  end
end
