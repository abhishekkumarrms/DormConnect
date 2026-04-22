"use client";
import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";
import { cn, healthScoreColor, healthScoreBg } from "@/lib/utils";

export default function HostelsPage() {
  const INSTITUTION_ID = process.env.NEXT_PUBLIC_INSTITUTION_ID || "";

  const { data, isLoading } = useQuery({
    queryKey: ["institution-overview", INSTITUTION_ID],
    queryFn: () => api.get(`/analytics/institution/${INSTITUTION_ID}`).then(r => r.data),
    enabled: !!INSTITUTION_ID,
  });

  return (
    <div className="p-8">
      <h2 className="text-xl font-bold text-slate-900 mb-6">Hostels</h2>

      {isLoading && (
        <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
          {Array(6).fill(0).map((_, i) => (
            <div key={i} className="h-40 bg-gray-100 rounded-xl animate-pulse" />
          ))}
        </div>
      )}

      {data && (
        <div className="grid grid-cols-2 lg:grid-cols-3 gap-4">
          {data.hostels.map((h: any) => (
            <div key={h.hostel_id} className={cn("rounded-xl border p-5 shadow-sm", healthScoreBg(h.health_score))}>
              <p className="font-semibold text-slate-900">{h.hostel_name}</p>
              <p className={cn("text-3xl font-bold mt-1 mb-3", healthScoreColor(h.health_score))}>
                {h.health_score}
              </p>
              <div className="grid grid-cols-2 gap-1 text-xs text-slate-600">
                <span>Students: {h.active_students}</span>
                <span>OUT now: {h.currently_out}</span>
                <span>On leave: {h.on_leave_today}</span>
                <span>Complaints: {h.pending_complaints}</span>
                <span>Maintenance: {h.pending_maintenance}</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
