const { initializeApp } = require('firebase-admin/app');
const { FieldValue, getFirestore } = require('firebase-admin/firestore');
const { onCall, HttpsError } = require('firebase-functions/v2/https');

initializeApp();
const db = getFirestore();

exports.reviewSubmission = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'Sign in is required.');
  }
  if (request.auth.token.admin !== true) {
    throw new HttpsError('permission-denied', 'Administrator access is required.');
  }

  const submissionId = request.data?.submissionId;
  const status = request.data?.status;
  if (typeof submissionId !== 'string' || submissionId.length === 0 || submissionId.length > 150) {
    throw new HttpsError('invalid-argument', 'A valid submissionId is required.');
  }
  if (status !== 'approved' && status !== 'rejected') {
    throw new HttpsError('invalid-argument', 'Status must be approved or rejected.');
  }

  const ref = db.collection('submissions').doc(submissionId);
  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    if (!snapshot.exists) {
      throw new HttpsError('not-found', 'Submission not found.');
    }
    if (snapshot.data().status !== 'pending') {
      throw new HttpsError('failed-precondition', 'Only pending submissions can be reviewed.');
    }
    transaction.update(ref, {
      status,
      reviewedBy: request.auth.uid,
      reviewedAt: FieldValue.serverTimestamp(),
    });
  });

  return { submissionId, status };
});
