"use client";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";

export default function StaffPage() {
  const [hostelId, setHostelId] = useState("");

  const { data, isLoading } = useQuery({
    queryKey: ["staff-perf", hostelId],
    queryFn: () => api.get(`/analytics/staff/${hostelId}`).then(r => r.data),
    enabled: !!hostelId,
  });

  return (
    <div className="p-8">
      <h2 className="text-xl font-bold text-slate-900 mb-6">Staff Performance</h2>

      <div className="mb-6">
        <input
          placeholder="Hostel ID (UUID)"
          value={hostelId}
          onChange={e => setHostelId(e.target.value)}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm w-80 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
      </div>

      {isLoading && (
        <div className="space-y-3">
          {Array(4).fill(0).map((_, i) => <div key={i} className="h-16 bg-gray-100 rounded-xl animate-pulse" />)}
        </div>
      )}

      {data && (
        <div className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide">
              <tr>
                <th className="px-4 py-3 text-left">Name</th>
                <th className="px-4 py-3 text-left">Role</th>
                <th className="px-4 py-3 text-right">Complaints Resolved</th>
                <th className="px-4 py-3 text-right">Leaves Processed</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {data.map((s: any) => (
                <tr key={s.user_id} className="hover:bg-indigo-50 transition-colors">
                  <td className="px-4 py-3 font-medium text-slate-900">{s.name}</td>
                  <td className="px-4 py-3 text-slate-500">{s.role.replace(/_/g, " ")}</td>
                  <td className="px-4 py-3 text-right text-green-600 font-semibold">{s.complaints_resolved}</td>
                  <td className="px-4 py-3 text-right text-indigo-600 font-semibold">{s.leaves_processed}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
