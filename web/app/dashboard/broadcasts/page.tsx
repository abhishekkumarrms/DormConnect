"use client";
import { useState } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { format } from "date-fns";

const CATEGORIES = ["GENERAL", "IMPORTANT", "MESS", "HOLIDAY", "EVENT"];

export default function BroadcastsPage() {
  const qc = useQueryClient();
  const [hostelId, setHostelId] = useState("");
  const [form, setForm] = useState({ title: "", body: "", category: "GENERAL", hostel_id: "" });
  const [sent, setSent] = useState(false);

  const { data: broadcasts, isLoading } = useQuery({
    queryKey: ["broadcasts", hostelId],
    queryFn: () => api.get(`/comms/broadcasts/${hostelId}`).then(r => r.data),
    enabled: !!hostelId,
  });

  const mutation = useMutation({
    mutationFn: (payload: typeof form) =>
      api.post("/comms/broadcast", { ...payload, hostel_id: payload.hostel_id || null }),
    onSuccess: () => {
      setSent(true);
      setForm({ title: "", body: "", category: "GENERAL", hostel_id: "" });
      qc.invalidateQueries({ queryKey: ["broadcasts"] });
      setTimeout(() => setSent(false), 3000);
    },
  });

  return (
    <div className="p-8 space-y-8">
      <h2 className="text-xl font-bold text-slate-900">Broadcasts</h2>

      <div className="bg-white rounded-xl border border-gray-200 p-6 shadow-sm max-w-lg">
        <h3 className="font-semibold text-slate-900 mb-4">Compose Broadcast</h3>
        <div className="space-y-3">
          <input
            placeholder="Title"
            value={form.title}
            onChange={e => setForm(f => ({ ...f, title: e.target.value }))}
            className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
          <textarea
            placeholder="Message body"
            rows={3}
            value={form.body}
            onChange={e => setForm(f => ({ ...f, body: e.target.value }))}
            className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 resize-none"
          />
          <div className="flex gap-3">
            <select
              value={form.category}
              onChange={e => setForm(f => ({ ...f, category: e.target.value }))}
              className="border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            >
              {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
            <input
              placeholder="Hostel ID (blank = all)"
              value={form.hostel_id}
              onChange={e => setForm(f => ({ ...f, hostel_id: e.target.value }))}
              className="flex-1 border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
          </div>
          {mutation.isError && (
            <p className="text-red-500 text-sm">{(mutation.error as any)?.response?.data?.detail ?? "Send failed"}</p>
          )}
          {sent && <p className="text-green-600 text-sm">Broadcast sent!</p>}
          <button
            onClick={() => mutation.mutate(form)}
            disabled={mutation.isPending || !form.title || !form.body}
            className="bg-indigo-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-indigo-700 disabled:opacity-50 transition-colors"
          >
            {mutation.isPending ? "Sending..." : "Send Broadcast"}
          </button>
        </div>
      </div>

      <div>
        <div className="flex items-center gap-3 mb-4">
          <h3 className="font-semibold text-slate-900">History</h3>
          <input
            placeholder="Hostel ID to load history"
            value={hostelId}
            onChange={e => setHostelId(e.target.value)}
            className="border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>
        {isLoading && <div className="h-32 bg-gray-100 rounded-xl animate-pulse" />}
        {broadcasts && (
          <div className="space-y-3">
            {broadcasts.map((b: any) => (
              <div key={b.id} className="bg-white rounded-xl border border-gray-200 p-4 shadow-sm">
                <div className="flex justify-between items-start">
                  <p className="font-medium text-slate-900">{b.title}</p>
                  <span className="text-xs text-slate-500">{format(new Date(b.created_at), "dd MMM HH:mm")}</span>
                </div>
                <p className="text-sm text-slate-600 mt-1">{b.body}</p>
                <p className="text-xs text-indigo-600 mt-2">{b.category} · {b.sent_by_name}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
