import { api } from "./api";

export interface UserInfo {
  user_id: string;
  role: string;
  access_token: string;
  refresh_token: string;
}

export async function login(email: string, password: string): Promise<UserInfo> {
  const res = await api.post("/auth/staff-login", { email, password });
  const data = res.data;
  if (typeof window !== "undefined") {
    localStorage.setItem("access_token", data.access_token);
    localStorage.setItem("refresh_token", data.refresh_token);
    localStorage.setItem("user", JSON.stringify({ user_id: data.user_id, role: data.role }));
  }
  return data;
}

export function logout() {
  if (typeof window !== "undefined") {
    localStorage.removeItem("access_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("user");
    window.location.href = "/login";
  }
}

export function getCurrentUser(): { user_id: string; role: string } | null {
  if (typeof window === "undefined") return null;
  const raw = localStorage.getItem("user");
  if (!raw) return null;
  try {
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

export function isAuthenticated(): boolean {
  if (typeof window === "undefined") return false;
  return !!localStorage.getItem("access_token");
}
