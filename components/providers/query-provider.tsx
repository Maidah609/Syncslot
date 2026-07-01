"use client";

import { useState } from "react";
import {
  QueryClient,
  QueryClientProvider,
} from "@tanstack/react-query";

export function QueryProvider({ children }: { children: React.ReactNode }) {
  // useState ensures the QueryClient is only created once per component
  // lifecycle, not on every render — required for React Query in App Router
  // since layout.tsx renders on the server but this provider runs on the client.
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000, // 1 minute — avoids refetching on every focus
            retry: 1,
          },
        },
      })
  );

  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
}
