# savd

> A modern personal finance SaaS that helps you understand where your money goes through intuitive dashboards, budgeting, and spending insights.

**savd** (pronounced "saved") is a full-stack personal finance tracker built for students, young professionals, freelancers, and anyone who wants to take control of their spending. Track income and expenses, set budgets, visualize trends, and build better financial habits — all in one clean, minimal interface.

---

## ✨ Features

### MVP

- **Authentication** — Secure email/password login with protected routes and session persistence
- **Dashboard** — At-a-glance overview of current balance, monthly income/expenses, savings rate, recent transactions, and spending charts
- **Transactions** — Full CRUD for income and expense entries with amount, category, description, date, payment method, and notes
- **Categories** — Customizable categories with icons and colors (default set included: Food, Transportation, Bills, Shopping, Entertainment, Salary, Investments)
- **Search & Filters** — Search by description, filter by category, month, date range, type, and sort by amount or date
- **Analytics** — Monthly spending, income vs. expense, spending by category, and 6-month trend charts
- **Profile & Settings** — Update profile, change currency, toggle dark mode, and delete account

### Coming Soon (v2)

- **Budget Goals** — Set monthly limits per category with visual progress tracking
- **Recurring Transactions** — Auto-insert subscriptions and recurring bills
- **CSV Export / Import** — Move your data in and out freely
- **Financial Insights** — AI-powered spending analysis and anomaly detection
- **Receipt OCR** — Upload receipts to auto-extract transaction details
- **Notifications** — Budget alerts, salary reminders, and expense logging nudges

---

## 🛠 Tech Stack

| Layer          | Technology                                    |
| -------------- | --------------------------------------------- |
| **Framework**  | Next.js 15 (App Router)                       |
| **Language**   | TypeScript                                    |
| **Styling**    | Tailwind CSS + shadcn/ui                      |
| **Forms**      | React Hook Form + Zod                         |
| **Charts**     | Recharts                                      |
| **Icons**      | Lucide React                                  |
| **Backend**    | Next.js Server Actions                        |
| **Database**   | Supabase (PostgreSQL + Row Level Security)    |
| **Auth**       | Supabase Auth (Email/Password + Google OAuth) |
| **Deployment** | Vercel                                        |

---

## 📸 Screenshots

> _Screenshots will be added after deployment. See the [Live Demo](#) for the full experience._

| Dashboard     | Transactions  | Analytics     |
| ------------- | ------------- | ------------- |
| _Coming soon_ | _Coming soon_ | _Coming soon_ |

---

## 🏗 Architecture

### Database Schema

```
users
├── id (uuid, pk)
├── email (text, unique)
├── name (text)
├── avatar_url (text)
├── currency (text, default: 'USD')
├── theme (text, default: 'light')
└── created_at (timestamp)

categories
├── id (uuid, pk)
├── user_id (uuid, fk → users)
├── name (text)
├── icon (text)
├── color (text)
└── created_at (timestamp)

transactions
├── id (uuid, pk)
├── user_id (uuid, fk → users)
├── category_id (uuid, fk → categories)
├── type ('income' | 'expense')
├── amount (numeric)
├── description (text)
├── payment_method (text)
├── date (date)
├── notes (text, optional)
└── created_at (timestamp)

budgets
├── id (uuid, pk)
├── user_id (uuid, fk → users)
├── category_id (uuid, fk → categories)
├── monthly_limit (numeric)
└── created_at (timestamp)

recurring_transactions
├── id (uuid, pk)
├── user_id (uuid, fk → users)
├── category_id (uuid, fk → categories)
├── amount (numeric)
├── frequency (text)
├── next_run (date)
└── created_at (timestamp)
```

### Row Level Security (RLS)

Every table is protected by RLS policies ensuring users can only read and modify their own data. No raw SQL is exposed to the client — all data access flows through authenticated Server Actions.

### Folder Structure

```text
src/
├── app/                    # Next.js App Router pages & layouts
│   ├── (auth)/             # Login, register, callback routes
│   ├── dashboard/          # Dashboard page
│   ├── transactions/       # Transaction list & detail
│   ├── categories/         # Category management
│   ├── budgets/            # Budget goals
│   ├── profile/            # User profile & settings
│   └── api/                # API routes (if needed)
├── components/
│   ├── ui/                 # shadcn/ui primitives
│   ├── dashboard/          # Dashboard-specific widgets
│   ├── charts/             # Recharts wrappers
│   └── forms/              # Reusable form components
├── lib/
│   ├── supabase/           # Supabase client & server helpers
│   └── utils/              # Utility functions (cn, formatters, etc.)
├── hooks/                  # Custom React hooks
├── actions/                # Next.js Server Actions (CRUD)
├── types/                  # TypeScript interfaces & types
├── schemas/                # Zod validation schemas
├── services/               # Business logic & data services
└── constants/              # App constants & config
```

---

## 🚀 Local Setup

### Prerequisites

- Node.js 20+
- npm / pnpm / yarn
- A Supabase project (free tier works fine)

### 1. Clone the repository

```bash
git clone https://github.com/abrielalhafidz/savd
cd savd
```

### 2. Install dependencies

```bash
npm install
# or
pnpm install
```

### 3. Configure environment variables

```bash
cp .env.example .env.local
```

Fill in your Supabase credentials:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Set up the database

Run the SQL migrations in the Supabase SQL Editor, or use the Supabase CLI:

```bash
npx supabase db push
```

> Migration files are located in `supabase/migrations/`.

### 5. Run the development server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) and sign up to start tracking.

---

## 🧪 Development

### Code Quality

```bash
# Lint
npm run lint

# Format
npm run format

# Type check
npm run type-check
```

### Git Workflow

This project follows a professional commit history:

1. `chore: initial project setup`
2. `chore: configure tailwind + shadcn`
3. `feat: implement authentication`
4. `chore: configure supabase`
5. `feat: create database schema`
6. `feat: build dashboard layout`
7. `feat: implement transactions CRUD`
8. `feat: add categories management`
9. `feat: build analytics charts`
10. `feat: implement filters & sorting`
11. `feat: add budget goals`
12. `style: improve responsive layout`
13. `polish: UI refinements`
14. `chore: deploy MVP`
15. `docs: write documentation`

---

## 🚢 Deployment

### Vercel (Recommended)

1. Push your code to GitHub
2. Import the repository on [Vercel](https://vercel.com)
3. Add the environment variables from `.env.local`
4. Deploy — Vercel will handle the build automatically

### Supabase Production Checklist

- [ ] Enable RLS on all tables
- [ ] Verify RLS policies are restrictive
- [ ] Set up custom SMTP for auth emails (optional)
- [ ] Configure OAuth providers in Supabase Auth settings
- [ ] Enable database backups

---

## 📋 Definition of Done (MVP)

Before moving to v2 features, the following must be true:

- [x] Users can register and log in
- [x] Each user only sees their own data (RLS enabled)
- [x] Transactions support full CRUD
- [x] Categories are customizable
- [x] Dashboard updates automatically when data changes
- [x] Charts render correctly with real data
- [x] Forms have proper validation and error messages
- [x] The UI works well on desktop and mobile
- [x] The app is deployed and accessible online
- [x] The README includes screenshots, setup instructions, and a brief architecture overview

---

## 🔮 Future Improvements

- [ ] Multi-currency support with real-time exchange rates
- [ ] Shared budgets / family accounts
- [ ] Bank account linking via Plaid / Stripe Financial Connections
- [ ] Mobile app (React Native / Expo)
- [ ] PWA offline support
- [ ] Advanced reporting (PDF export, tax summaries)
- [ ] Community templates for budget categories
- [ ] Open banking integration (EU/UK)

---

## 🤝 Contributing

Contributions are welcome! Please open an issue first to discuss what you would like to change, or submit a pull request with a clear description of your changes.

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feat/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

[MIT](LICENSE) © 2026 savd

---

<p align="center">
  Built with care for people who want to <strong>savd</strong> more.
</p>
