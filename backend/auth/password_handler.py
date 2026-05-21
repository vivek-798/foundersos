import bcrypt
import hashlib

def _pre_hash(password: str) -> bytes:
    # Pre-hash with SHA-256 to ensure the password is exactly 64 hex characters long.
    # This securely bypasses bcrypt's strict 72-byte length limit without losing entropy.
    return hashlib.sha256(password.encode('utf-8')).hexdigest().encode('utf-8')

def verify_password(plain_password: str, hashed_password: str) -> bool:
    try:
        return bcrypt.checkpw(_pre_hash(plain_password), hashed_password.encode('utf-8'))
    except Exception:
        return False

def get_password_hash(password: str) -> str:
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(_pre_hash(password), salt).decode('utf-8')