"use client";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { healthScoreColor, healthScoreBg, cn } from "@/lib/utils";
import { Users, TrendingUp, CalendarX, AlertTriangle } from "lucide-react";

interface HostelStats {
  hostel_id: string;
  hostel_name: string;
  total_students: number;
  active_students: number;
  currently_out: number;
  on_leave_today: number;
  pending_complaints: number;
  resolved_complaints: number;
  total_complaints: number;
  pending_maintenance: number;
  health_score: number;
}

interface InstitutionOverview {
  institution_id: string;
  institution_name: string;
  total_students: number;
  currently_out: number;
  hostels: HostelStats[];
}

function StatCard({ label, value, icon: Icon, color = "indigo" }: {
  label: string; value: number | string; icon: any; color?: string;
}) {
  const colors: Record<string, string> = {
    indigo: "bg-indigo-50 text-indigo-600",
    green: "bg-green-50 text-green-600",
    yellow: "bg-yellow-50 text-yellow-600",
    red: "bg-red-50 text-red-600",
  };
  return (
    <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
      <div className="flex items-center justify-between mb-3">
        <span className="text-sm text-gray-500">{label}</span>
        <span className={cn("p-2 rounded-lg", colors[color])}>
          <Icon size={16} />
        </span>
      </div>
      <p className="text-2xl font-bold text-slate-900">{value}</p>
    </div>
  );
}

function SkeletonCard() {
  return (
    <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm animate-pulse">
      <div className="h-4 bg-gray-200 rounded w-24 mb-3" />
      <div className="h-8 bg-gray-200 rounded w-16" />
    </div>
  );
}

export default function DashboardPage() {
  const INSTITUTION_ID = process.env.NEXT_PUBLIC_INSTITUTION_ID || "";

  const { data, isLoading, error } = useQuery<InstitutionOverview>({
    queryKey: ["institution-overview", INSTITUTION_ID],
    queryFn: () => api.get(`/analytics/institution/${INSTITUTION_ID}`).then(r => r.data),
    refetchInterval: 60000,
    enabled: !!INSTITUTION_ID,
  });

  if (!INSTITUTION_ID) {
    return (
      <div className="p-8">
        <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 text-yellow-800 text-sm">
          Set <code>NEXT_PUBLIC_INSTITUTION_ID</code> in <code>.env.local</code> to load dashboard data.
        </div>
      </div>
    );
  }

  const totalComplaints = data?.hostels.reduce((s, h) => s + h.total_complaints, 0) ?? 0;
  const pendingComplaints = data?.hostels.reduce((s, h) => s + h.pending_complaints, 0) ?? 0;
  const resolvedComplaints = data?.hostels.reduce((s, h) => s + h.resolved_complaints, 0) ?? 0;

  return (
    <div className="p-8 space-y-8">
      <div>
        <h2 className="text-xl font-bold text-slate-900">Institution Overview</h2>
        <p className="text-slate-500 text-sm mt-0.5">
          {data?.institution_name ?? "Loading..."} · refreshes every 60s
        </p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        {isLoading ? (
          Array(4).fill(0).map((_, i) => <SkeletonCard key={i} />)
        ) : (
          <>
            <StatCard label="Total Students" value={data?.total_students ?? 0} icon={Users} />
            <StatCard label="Currently OUT" value={data?.currently_out ?? 0} icon={TrendingUp} color="yellow" />
            <StatCard label="On Leave Today" value={data?.hostels.reduce((s, h) => s + h.on_leave_today, 0) ?? 0} icon={CalendarX} color="indigo" />
            <StatCard label="Pending Complaints" value={pendingComplaints} icon={AlertTriangle} color="red" />
          </>
        )}
      </div>

      {/* Hostel health scores */}
      <div>
        <h3 className="text-base font-semibold text-slate-900 mb-4">Hostel Health Scores</h3>
        <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
          {isLoading
            ? Array(6).fill(0).map((_, i) => <SkeletonCard key={i} />)
            : data?.hostels.map((h) => (
              <div
                key={h.hostel_id}
                className={cn("rounded-xl border p-4 shadow-sm", healthScoreBg(h.health_score))}
              >
                <p className="text-sm font-medium text-slate-700">{h.hostel_name}</p>
                <p className={cn("text-3xl font-bold mt-1", healthScoreColor(h.health_score))}>
                  {h.health_score}
                </p>
                <div className="mt-3 grid grid-cols-2 gap-x-4 gap-y-1 text-xs text-slate-600">
                  <span>Students: {h.active_students}</span>
                  <span>OUT: {h.currently_out}</span>
                  <span>Complaints: {h.pending_complaints} open</span>
                  <span>Maintenance: {h.pending_maintenance} open</span>
                </div>
              </div>
            ))}
        </div>
      </div>

      {/* Complaints week summary */}
      <div className="bg-white rounded-xl border border-gray-200 p-5 shadow-sm">
        <h3 className="text-base font-semibold text-slate-900 mb-4">Complaints Summary</h3>
        <div className="flex gap-8 text-sm">
          <div><span className="text-slate-500">Total</span><p className="text-xl font-bold text-slate-900">{totalComplaints}</p></div>
          <div><span className="text-slate-500">Open</span><p className="text-xl font-bold text-yellow-500">{pendingComplaints}</p></div>
          <div><span className="text-slate-500">Resolved</span><p className="text-xl font-bold text-green-600">{resolvedComplaints}</p></div>
          <div>
            <span className="text-slate-500">Resolution Rate</span>
            <p className="text-xl font-bold text-indigo-600">
              {totalComplaints > 0 ? Math.round((resolvedComplaints / totalComplaints) * 100) : 0}%
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
