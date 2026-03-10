# TaskFlow (Mini TaskHub)

A sleek and responsive personal task tracker built with **Flutter** and powered by **Supabase** for secure authentication and real-time database management.

## 🚀 Features

*   **User Authentication**: Secure Sign-Up and Login using Supabase Email/Password authentication.
*   **Task Management (CRUD)**: 
    *   Create new tasks effortlessly.
    *   Read your personal tasks securely synced from the cloud.
    *   Update tasks (edit text or toggle completion status).
    *   Delete tasks manually (completed tasks are also auto-deleted after 1 minute).
*   **Profile Dashboard**: View user details and track statistics like completed vs. incomplete tasks.
*   **Persistent Sessions**: Stay logged in even after closing the application.
*   **Modern UI**: Built with a clean, dynamic aesthetic using Google Fonts (`Luxurious Roman`).

## 🛠️ Technology Stack

*   **Frontend**: Flutter (Dart)
*   **Backend as a Service (BaaS)**: Supabase
    *   *Supabase Auth* for user management
    *   *Supabase Postgres Database* for task storage
*   **State Management**: Stateful Widgets & setState

## 📋 Prerequisites

Before you begin, ensure you have met the following requirements:
*   You have installed the [Flutter SDK](https://docs.flutter.dev/get-started/install).
*   You have an IDE like VS Code or Android Studio installed.
*   You have an active [Supabase](https://supabase.com/) account and project.

## ⚙️ Backend Setup (Supabase)

1. Create a new project in Supabase.
2. Go to your **Project Settings > API** and copy your `Project URL` and `anon public key`. These need to be placed inside `lib/main.dart` in the `Supabase.initialize()` function.
3. Open the **SQL Editor** in Supabase and run the following script to create the `tasks` table and secure the data using Row Level Security (RLS):

```sql
create table public.tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null default auth.uid(),
  title text not null,
  is_done boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable Row Level Security (RLS)
alter table public.tasks enable row level security;

-- Create policies so users only see and manage their own tasks
create policy "Users can view their own tasks" on public.tasks for select using (auth.uid() = user_id);
create policy "Users can insert their own tasks" on public.tasks for insert with check (auth.uid() = user_id);
create policy "Users can update their own tasks" on public.tasks for update using (auth.uid() = user_id);
create policy "Users can delete their own tasks" on public.tasks for delete using (auth.uid() = user_id);
```

4. Go to **Authentication > Providers > Email** in Supabase and toggle **Confirm email** to **OFF** to prevent rate-limit errors during development.

## 💻 Running the App

1. Clone or download the repository.
2. Open the project folder (`task_manager`) in your terminal.
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application on your emulator or physical device:
   ```bash
   flutter run
   ```

## 📂 Project Structure

*   `lib/main.dart`: App entry point and Supabase initialization.
*   `lib/Screens/homescreen.dart`: Welcome screen.
*   `lib/Screens/registrationpage.dart`: Supabase Sign-Up flow.
*   `lib/Screens/loginpage.dart`: Supabase Login flow.
*   `lib/Screens/taskscreen.dart`: Main dashboard featuring Task CRUD operations.
*   `lib/Screens/profilescreen.dart`: User details, task statistics, and secure logout.
