"use client";
import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { format } from "date-fns";

export default function AuditPage() {
  const [action, setAction] = useState("");
  const [entityType, setEntityType] = useState("");
  const [page, setPage] = useState(0);
  const limit = 50;

  const { data, isLoading } = useQuery({
    queryKey: ["audit", action, entityType, page],
    queryFn: () =>
      api.get("/audit/", {
        params: {
          action: action || undefined,
          entity_type: entityType || undefined,
          limit,
          offset: page * limit,
        },
      }).then(r => r.data),
  });

  return (
    <div className="p-8">
      <h2 className="text-xl font-bold text-slate-900 mb-6">Audit Logs</h2>

      <div className="flex gap-3 mb-6">
        <input
          placeholder="Filter by action (e.g. GATE)"
          value={action}
          onChange={e => { setAction(e.target.value); setPage(0); }}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm w-56 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
        <input
          placeholder="Entity type (e.g. Student)"
          value={entityType}
          onChange={e => { setEntityType(e.target.value); setPage(0); }}
          className="border border-gray-200 rounded-lg px-3 py-2 text-sm w-56 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        />
      </div>

      {isLoading && (
        <div className="space-y-2">
          {Array(10).fill(0).map((_, i) => <div key={i} className="h-12 bg-gray-100 rounded-xl animate-pulse" />)}
        </div>
      )}

      {data && (
        <>
          <div className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 text-gray-500 text-xs uppercase tracking-wide">
                <tr>
                  <th className="px-4 py-3 text-left">Time</th>
                  <th className="px-4 py-3 text-left">Action</th>
                  <th className="px-4 py-3 text-left">Entity</th>
                  <th className="px-4 py-3 text-left">Entity ID</th>
                  <th className="px-4 py-3 text-left">By</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {data.map((log: any, i: number) => (
                  <tr key={log.id} className={i % 2 === 0 ? "" : "bg-gray-50/50"}>
                    <td className="px-4 py-3 text-slate-500 text-xs">{format(new Date(log.created_at), "dd MMM HH:mm:ss")}</td>
                    <td className="px-4 py-3 font-medium text-slate-900 text-xs">{log.action}</td>
                    <td className="px-4 py-3 text-slate-600 text-xs">{log.entity_type}</td>
                    <td className="px-4 py-3 text-slate-500 text-xs font-mono">{log.entity_id.slice(0, 8)}…</td>
                    <td className="px-4 py-3 text-slate-500 text-xs font-mono">{log.performed_by?.slice(0, 8) ?? "—"}…</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="flex gap-3 mt-4">
            <button
              onClick={() => setPage(p => Math.max(0, p - 1))}
              disabled={page === 0}
              className="px-4 py-2 text-sm border border-gray-200 rounded-lg disabled:opacity-40 hover:bg-gray-50"
            >
              Previous
            </button>
            <span className="px-4 py-2 text-sm text-slate-500">Page {page + 1}</span>
            <button
              onClick={() => setPage(p => p + 1)}
              disabled={data.length < limit}
              className="px-4 py-2 text-sm border border-gray-200 rounded-lg disabled:opacity-40 hover:bg-gray-50"
            >
              Next
            </button>
          </div>
        </>
      )}
    </div>
  );
}
