"use client";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { format } from "date-fns";
import { cn } from "@/lib/utils";

const STATUS_COLORS: Record<string, string> = {
  PENDING: "bg-yellow-100 text-yellow-700",
  APPROVED: "bg-green-100 text-green-700",
  REJECTED: "bg-red-100 text-red-700",
  CANCELLED: "bg-gray-100 text-gray-700",
  RETURNED: "bg-blue-100 text-blue-700",
};

export default function LeavesPage() {
  const [hostelId, setHostelId] = useState("");
  const [statusFilter, setStatusFilter] = useState("");

  const { data, isLoading } = useQuery({
    queryKey: ["leaves", hostelId, statusFilter],
    queryFn: () =>
      api.get("/leaves/", {
        params: { hostel_id: hostelId, status: statusFilter || undefined },
      }).then(r => r.data),
    enabled: !!hostelId,
  });

  return (
    <div className="p-8">
      <h2 className="text-xl font-bold text-slate-900 mb-6">Leave Requests</h2>

      <div className="flex gap-3 mb-6">
        <input
          placeholder="Hostel ID (UUID)"
          value={hostelId}
          onChange={e => setHostelId(e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm flex-1 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
        <select
          value={statusFilter}
          onChange={e => setStatusFilter(e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
        >
          <option value="">All Status</option>
          {Object.keys(STATUS_COLORS).map(s => <option key={s} value={s}>{s}</option>)}
        </select>
      </div>

      {isLoading && (
        <div className="space-y-3">
          {Array(5).fill(0).map((_, i) => (
            <div key={i} className="h-16 bg-gray-100 rounded-xl animate-pulse" />
          ))}
        </div>
      )}

      {!isLoading && data && (
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide">
              <tr>
                <th className="px-4 py-3 text-left">Student</th>
                <th className="px-4 py-3 text-left">Room</th>
                <th className="px-4 py-3 text-left">From</th>
                <th className="px-4 py-3 text-left">To</th>
                <th className="px-4 py-3 text-left">Status</th>
                <th className="px-4 py-3 text-left">Applied</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {data.map((l: any, i: number) => (
                <tr key={l.id} className={cn(i % 2 === 0 ? "" : "bg-gray-50/50")}>
                  <td className="px-4 py-3 font-medium text-slate-900">{l.student_name}</td>
                  <td className="px-4 py-3 text-slate-600">{l.room_number}</td>
                  <td className="px-4 py-3 text-slate-600">{format(new Date(l.from_date), "dd MMM")}</td>
                  <td className="px-4 py-3 text-slate-600">{format(new Date(l.to_date), "dd MMM yyyy")}</td>
                  <td className="px-4 py-3">
                    <span className={cn("px-2 py-0.5 rounded-full text-xs font-medium", STATUS_COLORS[l.status] ?? "bg-gray-100 text-gray-700")}>
                      {l.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-slate-500">{format(new Date(l.created_at), "dd MMM yyyy")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
