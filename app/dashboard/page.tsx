import { createClient } from "@/lib/supabase/server"
import { redirect } from "next/navigation"

export default async function DashboardPage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect("/login")
  }

  return (
    <div className="min-h-screens p-8">
      <div className="mx-auto max-w-4xl">
        <h1 className="mb-4 text-3xl font-bold">Welcome to savd!</h1>
        <p className="mb-8 text-muted-foreground">
          You&apos;re logged in as {user.email}
        </p>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          <div className="rounded-lg border bg-card p-6">
            <h3 className="text-sm font-medium text-muted-foreground">
              Balance
            </h3>
            <p className="mt-2 text-2xl font-bold">$0.00</p>
          </div>
          <div className="rounded-lg border bg-card p-6">
            <h3 className="text-sm font-medium text-muted-foreground">
              Income
            </h3>
            <p className="mt-2 text-2xl font-bold text-green-600">$0.00</p>
          </div>
          <div className="rounded-lg border bg-card p-6">
            <h3 className="text-sm font-medium text-muted-foreground">
              Expenses
            </h3>
            <p className="mt-2 text-2xl font-bold text-red-600">$0.00</p>
          </div>
          <div className="rounded-lg border bg-card p-6">
            <h3 className="text-sm font-medium text-muted-foreground">
              Savings Rate
            </h3>
            <p className="mt-2 text-2xl font-bold">0%</p>
          </div>
        </div>

        <div className="mt-8 rounded-lg border bg-card p-6">
          <h2 className="mb-4 text-xl font-semibold">Recent Transactions</h2>
          <p className="text-muted-foreground">
            No transactions yet. Start tracking your finances!
          </p>
        </div>
      </div>
    </div>
  )
}
