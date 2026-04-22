"use client";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { format } from "date-fns";
import { cn } from "@/lib/utils";

interface Complaint {
  id: string;
  student_name: string;
  room_number: string;
  category: string;
  status: string;
  description: string;
  created_at: string;
  updates: Array<{ updated_by_name: string; old_status: string; new_status: string; note: string; created_at: string }>;
}

const STATUS_COLORS: Record<string, string> = {
  SUBMITTED: "bg-gray-100 text-gray-700",
  ACCEPTED: "bg-blue-100 text-blue-700",
  IN_PROGRESS: "bg-yellow-100 text-yellow-700",
  RESOLVED: "bg-green-100 text-green-700",
  REJECTED: "bg-red-100 text-red-700",
  ESCALATED: "bg-orange-100 text-orange-700",
  REOPENED: "bg-purple-100 text-purple-700",
};

export default function ComplaintsPage() {
  const [hostelId, setHostelId] = useState("");
  const [statusFilter, setStatusFilter] = useState("");
  const [selected, setSelected] = useState<Complaint | null>(null);

  const { data, isLoading } = useQuery<Complaint[]>({
    queryKey: ["complaints", hostelId, statusFilter],
    queryFn: () =>
      api.get("/complaints/", {
        params: { hostel_id: hostelId, status: statusFilter || undefined },
      }).then(r => r.data),
    enabled: !!hostelId,
  });

  return (
    <div className="p-8">
      <h2 className="text-xl font-bold text-slate-900 mb-6">Complaints</h2>

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
                <th className="px-4 py-3 text-left">Category</th>
                <th className="px-4 py-3 text-left">Status</th>
                <th className="px-4 py-3 text-left">Date</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {data.map((c, i) => (
                <tr
                  key={c.id}
                  className={cn("cursor-pointer hover:bg-indigo-50 transition-colors", i % 2 === 0 ? "" : "bg-gray-50/50")}
                  onClick={() => setSelected(c)}
                >
                  <td className="px-4 py-3 font-medium text-slate-900">{c.student_name}</td>
                  <td className="px-4 py-3 text-slate-600">{c.room_number}</td>
                  <td className="px-4 py-3 text-slate-600">{c.category}</td>
                  <td className="px-4 py-3">
                    <span className={cn("px-2 py-0.5 rounded-full text-xs font-medium", STATUS_COLORS[c.status] ?? "bg-gray-100 text-gray-700")}>
                      {c.status}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-slate-500">{format(new Date(c.created_at), "dd MMM yyyy")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Detail modal */}
      {selected && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <div className="bg-white rounded-2xl shadow-2xl p-6 max-w-lg w-full" onClick={e => e.stopPropagation()}>
            <div className="flex justify-between items-start mb-4">
              <div>
                <h3 className="font-bold text-slate-900">{selected.student_name} · Room {selected.room_number}</h3>
                <p className="text-sm text-slate-500">{selected.category}</p>
              </div>
              <span className={cn("px-2 py-0.5 rounded-full text-xs font-medium", STATUS_COLORS[selected.status])}>
                {selected.status}
              </span>
            </div>
            <p className="text-sm text-slate-700 mb-4">{selected.description}</p>
            {selected.updates.length > 0 && (
              <div>
                <p className="text-xs font-semibold text-slate-500 uppercase mb-2">History</p>
                <div className="space-y-2">
                  {selected.updates.map((u, i) => (
                    <div key={i} className="text-xs bg-gray-50 rounded-lg p-3">
                      <p className="font-medium text-slate-700">{u.updated_by_name}: {u.old_status} → {u.new_status}</p>
                      {u.note && <p className="text-slate-500 mt-1">{u.note}</p>}
                    </div>
                  ))}
                </div>
              </div>
            )}
            <button onClick={() => setSelected(null)} className="mt-4 text-sm text-indigo-600 hover:underline">Close</button>
          </div>
        </div>
      )}
    </div>
  );
}
