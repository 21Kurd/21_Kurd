import { applicationDefault, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';

const [uid] = process.argv.slice(2);
const projectId = process.env.FIREBASE_PROJECT_ID;
if (!uid || !projectId) {
  console.error('Usage: FIREBASE_PROJECT_ID=<project-id> node functions/scripts/set-admin-claim.mjs <auth-uid>');
  process.exit(1);
}

initializeApp({ credential: applicationDefault(), projectId });
const auth = getAuth();
const user = await auth.getUser(uid);
await auth.setCustomUserClaims(uid, { ...user.customClaims, admin: true });
console.log('Admin claim assigned. Refresh the user ID token by signing out and back in.');
