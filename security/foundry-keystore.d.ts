export function loadPrivateKey(role?: string, required?: true): string;
export function loadPrivateKey(role: string, required: false): string | undefined;
export function loadPrivateKeys(...roles: string[]): string[];
