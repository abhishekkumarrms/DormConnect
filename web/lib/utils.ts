import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function healthScoreColor(score: number): string {
  if (score >= 80) return "text-green-600";
  if (score >= 60) return "text-yellow-500";
  return "text-red-500";
}

export function healthScoreBg(score: number): string {
  if (score >= 80) return "bg-green-100 border-green-200";
  if (score >= 60) return "bg-yellow-50 border-yellow-200";
  return "bg-red-50 border-red-200";
}
